//  Created by Geoff Pado on 2/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AppKit

class AlertWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        backgroundColor = .clear
        acceptsMouseMovedEvents = true
        ignoresMouseEvents = true
        level = NSWindow.Level(Int(CGShieldingWindowLevel()))
    }

    var alertViewController: AlertViewController? { windowController?.contentViewController as? AlertViewController }
}
