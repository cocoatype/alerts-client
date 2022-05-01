//  Created by Geoff Pado on 2/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Cocoa
import CoreMediaIO

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    override init() {
        client = ChatClient(name: "cocoatype")
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.deactivate()

        Task {
            do {
                try await client.start()
                print("chat started")
            } catch {
                fatalError(String(describing: error))
            }
        }
    }

    func application(_ sender: NSApplication, delegateHandlesKey key: String) -> Bool {
        return key == "devices"
    }

    @objc var sharedOverlayController = DeviceVideoController()
    @objc var devices: [Device] {
        guard let alertWindow = NSApp.windows.compactMap({ $0 as? AlertWindow }).first,
              let alertViewController = alertWindow.alertViewController
              else { return [] }
        return alertViewController.devices
    }

    private let client: ChatClient
}
