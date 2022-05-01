//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa
import TwitchChat

class ChatBubble: NSView {
    convenience init(message: ChatMessage) async {
        let color: NSColor
        if let colorString = message.senderColor {
            color = NSColor(hexString: colorString) ?? .white
        } else { color = .white }

        await self.init(speakerName: message.sender, speakerColor: color,
                  message: ChatMessageRenderer.attributedString(for: message))
    }

    init(speakerName: String, speakerColor: NSColor, message: NSAttributedString) {
        speakerLabel = ChatSpeakerLabel(name: speakerName, color: speakerColor)
        messageLabel = ChatMessageLabel(message: message)
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true

        addSubview(background)
        addSubview(border)
        addSubview(speakerLabel)
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.topAnchor.constraint(equalTo: topAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            speakerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            speakerLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            speakerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.topAnchor.constraint(equalTo: speakerLabel.bottomAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: speakerLabel.leadingAnchor)
        ])
    }

    // MARK: Boilerplate

    private let background = ChatBubbleBackground()
    private let border = ChatBubbleBorder()

    private let speakerLabel: ChatSpeakerLabel
    private let messageLabel: ChatMessageLabel

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
