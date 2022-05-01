//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa
import TwitchChat

class ChatView: NSView {
    init(message: ChatMessage) async {
        bubble = await ChatBubble(message: message)
        super.init(frame: .zero)

        addSubview(bubble)

        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: topAnchor, constant: ChatWindowController.windowPadding),
            bubble.trailingAnchor.constraint(equalTo: trailingAnchor),
            bubble.bottomAnchor.constraint(equalTo: bottomAnchor),
            bubble.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    func animateIn() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let slideAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        slideAnimation.fromValue = (bubble.frame.size.height + ChatWindowController.windowPadding)
        slideAnimation.toValue = 0
        slideAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        bubble.layer?.add(slideAnimation, forKey: "slide")

        CATransaction.commit()
    }

    func animateOut() async {
        return await withCheckedContinuation { continuation in
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            CATransaction.setCompletionBlock {
                continuation.resume()
            }

            let slideAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            slideAnimation.fromValue = 0
            slideAnimation.toValue = (bubble.frame.size.height + ChatWindowController.windowPadding)
            slideAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            bubble.layer?.add(slideAnimation, forKey: "slide")

            CATransaction.commit()

            bubble.layer?.transform = CATransform3DMakeTranslation(0, (bubble.frame.size.height + ChatWindowController.windowPadding), 0)
        }
    }

    // MARK: Boilerplate

    private let bubble: ChatBubble

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
