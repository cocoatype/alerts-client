//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import AppKit

class AlertWindowController: NSWindowController, NSWindowDelegate {
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.delegate = self
    }

    func windowDidChangeScreen(_ notification: Notification) {
        if let screenFrame = window?.screen?.frame {
            window?.setFrame(screenFrame, display: true)
            window?.contentViewController?.preferredContentSize = screenFrame.size
        }
    }
}
