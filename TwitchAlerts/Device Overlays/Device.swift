//  Created by Geoff Pado on 6/4/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AppKit
import AVFoundation

@objc(Device) class Device: NSObject {
    @objc(uniqueID) let uniqueID: String
    @objc(name) let name: String
    let size: CGSize
    var visibility: Visibility = Visibility.pip {
        didSet {
            NotificationCenter.default.post(name: Self.visibilityDidChange, object: self)
        }
    }
    @objc(visibility) var visibilityCode: OSType {
        get { visibility.code }
        set(newCode) {
            if let newVisibility = Visibility(code: newCode) {
                visibility = newVisibility
            }
        }
    }

    init(_ captureDevice: AVCaptureDevice) {
        self.name = captureDevice.localizedName
        self.uniqueID = captureDevice.uniqueID
        self.size = captureDevice.activeFormat.formatDescription.presentationDimensions()
    }

    override var objectSpecifier: NSScriptObjectSpecifier? {
        let overlayController = (NSApp.delegate as! AppDelegate).sharedOverlayController

        return NSUniqueIDSpecifier(containerClassDescription: overlayController.classDescription as! NSScriptClassDescription, containerSpecifier: overlayController.objectSpecifier, key: "devices", uniqueID: uniqueID)
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Device else { return false }
        return other.uniqueID == uniqueID
    }

    static let visibilityDidChange = Notification.Name("Device.visibilityDidChange")
}
