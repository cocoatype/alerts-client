//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa
import TwitchChat

class ChatWindow: NSWindow {
    init(contentRect: NSRect, message: ChatMessage) async {
        chatViewController = await ChatViewController(message: message)
        super.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: true)
        backgroundColor = .clear
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        ignoresMouseEvents = true
        isOpaque = false
        level = NSWindow.Level(Int(CGShieldingWindowLevel()) + 1)

        contentViewController = chatViewController
        hasShadow = true
    }

    let chatViewController: ChatViewController
}
