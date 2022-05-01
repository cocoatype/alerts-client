//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa
import TwitchChat

class ChatWindowController: NSWindowController, NSWindowDelegate {
    static let windowPadding = CGFloat(20)

    init(message: ChatMessage) async {
        let window = await ChatWindow(
            contentRect: NSRect(
                origin: .zero,
                size: CGSize(width: 320, height: 64)),
            message: message)
        super.init(window: window)
        window.delegate = self
    }

    func displayWindow() {
        window?.orderFront(NSApp)

        let viewSize = chatView?.fittingSize ?? CGSize(width: 320, height: 64)

        let screenFrame = NSScreen.main!.frame
        let origin = CGPoint(x: (screenFrame.width - viewSize.width) / 2, y: screenFrame.height - viewSize.height)
        window?.setFrame(CGRect(origin: origin, size: viewSize), display: true)

        chatView?.animateIn()

        Task.detached { [chatView, window] in
            try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
            _ = await MainActor.run {
                Task {
                    await chatView?.animateOut()
                    window?.orderOut(self)
                }
            }
        }
    }

    // MARK: Boilerplate

    private var chatView: ChatView? { window?.contentView as? ChatView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
