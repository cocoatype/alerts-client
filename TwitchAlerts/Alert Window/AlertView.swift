//  Created by Geoff Pado on 2/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AppKit
import Combine

class AlertView: NSView {
    init(apiPublisher: AnyPublisher<TwitchFollowEvent, Never>) {
        self.alertNativeView = AlertNativeView(apiPublisher: apiPublisher)
        super.init(frame: .zero)

        addSubview(alertNativeView)
        addSubview(alertWebView)
        addSubview(deviceView)

        NSLayoutConstraint.activate([
            alertNativeView.topAnchor.constraint(equalTo: topAnchor),
            alertNativeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            alertNativeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            alertNativeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            alertWebView.topAnchor.constraint(equalTo: topAnchor),
            alertWebView.trailingAnchor.constraint(equalTo: trailingAnchor),
            alertWebView.bottomAnchor.constraint(equalTo: bottomAnchor),
            alertWebView.leadingAnchor.constraint(equalTo: leadingAnchor),
            deviceView.topAnchor.constraint(equalTo: topAnchor),
            deviceView.trailingAnchor.constraint(equalTo: trailingAnchor),
            deviceView.bottomAnchor.constraint(equalTo: bottomAnchor),
            deviceView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    var devices: [Device] { deviceView.devices }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.clear.set()
        NSBezierPath(rect: bounds).fill()
    }

    // MARK: Boilerplate

    private let alertNativeView: AlertNativeView
    private let alertWebView = AlertWebView()
    private let deviceView = DeviceView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
