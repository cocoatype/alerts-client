//  Created by Geoff Pado on 5/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AppKit
import AVFoundation
import CoreMediaIO

class DeviceView: NSView, CALayerDelegate {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.addSublayer(fullscreenBackgroundLayer)
        layer?.addSublayer(videoPreviewLayer)
        layer?.addSublayer(phoneFrameLayer)

        disconnectionObserver = NotificationCenter.default
            .addObserver(forName: .AVCaptureDeviceWasDisconnected, object: nil, queue: nil)
            { [weak self] notification -> Void in
                guard let device = notification.object as? AVCaptureDevice else { return }
                self?.handleDisconnection(device: device)
            }
        connectionObserver = NotificationCenter.default
            .addObserver(forName: .AVCaptureDeviceWasConnected, object: nil, queue: nil)
            { [weak self] notification -> Void in
                guard let device = notification.object as? AVCaptureDevice else { return }
                self?.handleConnection(device: device)
            }

        enableScreenCapture()
        discoverConnectedDevices()
        postsFrameChangedNotifications = true

        frameObserver = NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: self, queue: .main) { [weak self] _ in
            guard let view = self else { return }
            view.fullscreenBackgroundLayer.frame = view.bounds
            view.phoneFrameLayer.frame = view.bounds
            view.resetTrackingArea()
        }

        visibilityObserver = NotificationCenter.default.addObserver(forName: Device.visibilityDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let view = self, let device = notification.object as? Device else { return }
            if view.devices.contains(device) {
                view.visibility = device.visibility
            }
        }

        formatObserver = NotificationCenter.default.addObserver(forName: .AVCaptureInputPortFormatDescriptionDidChange,
                                                                object: nil,
                                                                queue: nil) { [weak self] notification in
            guard let port = notification.object as? AVCaptureInput.Port,
                  let formatDescription = port.formatDescription
            else { return }

            self?.formatDimensions = formatDescription.presentationDimensions()
        }
    }

    var devices: [Device] {
        AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: nil, position: .unspecified).devices.filter(isConnectableDevice(_:)).map(Device.init(_:))
    }

    // MARK: Setup

    private func enableScreenCapture() {
        var prop = CMIOObjectPropertyAddress(
                mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
                mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
                mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))

        var allow: UInt32 = 1

        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject),
                &prop,
                0,
                nil,
                UInt32(MemoryLayout<UInt32>.size),
                &allow)
    }

    private func discoverConnectedDevices() {
        AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: nil, position: .unspecified).devices.forEach(handleConnection(device:))
    }

    // MARK: Device Frames

    private func deviceFrameImage(for size: CGSize) -> NSImage? {
        if size.width > 500 && size.width > size.height { // landscape ipad
            return NSImage(named: "iPad-Landscape")
        } else if size.width > 500 { // portrait iPad
            return NSImage(named: "iPad-Portrait")
        } else { // phone
            return NSImage(named: "SE-Frame")
        }

    }

    // MARK: Layout

    private var formatDimensions = CGSize.zero {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            phoneFrameLayer.contents = deviceFrameImage(for: formatDimensions)
            videoPreviewLayer.frame = currentFrame
            CATransaction.commit()
            resetTrackingArea()
        }
    }

    private var currentFrame: CGRect {
        switch visibility {
        case .fullscreen: return fullFrame
        case .pip, .hidden: return pipFrame
        }
    }

    private var pipFrame: CGRect {
        CGRect(origin: CGPoint(x: bounds.width - pipSize.width - 20, y: 20), size: pipSize)
    }

    private var pipSize: CGSize {
        let fullRect = CGRect(origin: .zero, size: formatDimensions)
        let frameRect = CGRect(origin: .zero, size: CGSize(width: 512, height: 512))
        let fittingRect = fullRect.fitting(rect: frameRect)
        return fittingRect.size
    }

    private var fullFrame: CGRect {
        CGRect(origin: CGPoint(x: (bounds.width - fullSize.width) / 2.0, y: (bounds.height - fullSize.height) / 2.0), size: fullSize)
    }

    private var fullSize: CGSize {
        formatDimensions / CGFloat(2)
    }

    // MARK: Connection/Disconnection

    private func isConnectableDevice(_ device: AVCaptureDevice) -> Bool {
        return device.modelID == "iOS Device"
    }

    private func handleConnection(device: AVCaptureDevice) {
        guard isConnectableDevice(device), let input = try? AVCaptureDeviceInput(device: device) else { return }
        session.addInput(input)
        session.startRunning()
        videoPreviewLayer.opacity = 1
    }

    private func handleDisconnection(device: AVCaptureDevice) {
        session.inputs.forEach { session.removeInput($0) }
        session.stopRunning()
        videoPreviewLayer.opacity = session.inputs.count == 0 ? 0 : 1
    }

    func layoutSublayers(of layer: CALayer) {
        videoPreviewLayer.frame = layer.bounds
    }

    // MARK: Visibility

    private var visibility: Device.Visibility = .pip {
        didSet {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            switch visibility {
            case .pip:
                fullscreenBackgroundLayer.opacity = 0
                videoPreviewLayer.opacity = 1
                videoPreviewLayer.frame = pipFrame
                phoneFrameLayer.opacity = 0
            case .hidden:
                fullscreenBackgroundLayer.opacity = 0
                videoPreviewLayer.opacity = 0
                phoneFrameLayer.opacity = 0
            case .fullscreen:
                fullscreenBackgroundLayer.opacity = 1
                videoPreviewLayer.opacity = 1
                videoPreviewLayer.frame = fullFrame
                phoneFrameLayer.opacity = 1
            }
            CATransaction.commit()
        }
    }

    // MARK: Mouseover

    private func resetTrackingArea() {
        trackingAreas.forEach(removeTrackingArea(_:))
        addTrackingArea(NSTrackingArea(rect: pipFrame, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil))
    }

    override func mouseEntered(with event: NSEvent) {
        guard case .pip = visibility else { return }
        videoPreviewLayer.opacity = 0.3
    }

    override func mouseExited(with event: NSEvent) {
        guard case .pip = visibility else { return }
        videoPreviewLayer.opacity = 1
    }

    // MARK: Boilerplate

    private var connectionObserver: Any?
    private var disconnectionObserver: Any?
    private var formatObserver: Any?
    private var frameObserver: Any?
    private var visibilityObserver: Any?

    private let session = AVCaptureSession()
    private lazy var videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)

    private let phoneFrameLayer: CALayer = {
        let layer = CALayer()
        layer.contentsGravity = .center
        layer.opacity = 0
        return layer
    }()

    private let fullscreenBackgroundLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = NSColor.black.cgColor
        layer.opacity = 0
        return layer
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
