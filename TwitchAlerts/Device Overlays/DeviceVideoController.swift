//  Created by Geoff Pado on 5/23/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AppKit
import AVFoundation

@objc(DeviceVideoController) class DeviceVideoController: NSObject {
    @objc var devices: [Device] {
        AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: nil, position: .unspecified).devices.map(Device.init(_:))
    }

    override var objectSpecifier: NSScriptObjectSpecifier? {
        NSPropertySpecifier(containerClassDescription: NSApp.classDescription as! NSScriptClassDescription, containerSpecifier: nil, key: "sharedOverlayController")
    }

    override func indicesOfObjects(byEvaluatingObjectSpecifier specifier: NSScriptObjectSpecifier) -> [NSNumber]? {
        return nil
    }
}

extension OSType {
    var string: String {
        String([
            Character(Unicode.Scalar(self >> 24 & 0xFF) ?? "?"),
            Character(Unicode.Scalar(self >> 16 & 0xFF) ?? "?"),
            Character(Unicode.Scalar(self >> 8 & 0xFF) ?? "?"),
            Character(Unicode.Scalar(self & 0xFF) ?? "?")
        ])
    }
}
