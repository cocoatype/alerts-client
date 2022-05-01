//  Created by Geoff Pado on 6/4/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AVFoundation
import SpriteKit

class FollowerScene: SKScene, AVAudioPlayerDelegate {
    private let label: SKLabelNode
    private let effectNode: SKEffectNode

    override init(size: CGSize) {
        label = SKLabelNode(text: "test")
        effectNode = SKEffectNode()
        super.init(size: size)

        addChild(effectNode)
        effectNode.addChild(label)

        effectNode.alpha = 0.0
        backgroundColor = .clear
        scaleMode = .aspectFill
    }

    func start(for follower: String) {
        setLabelText(follower: follower)
        audioPlayer.seek(to: .zero)
        audioPlayer.play()
        showLabel()
    }

    override func didMove(to view: SKView) {
        effectNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }

    // MARK: Effects

    private func showLabel() {
        effectNode.run(FollowActionRandomizer.randomAction())
    }

    // MARK: Text

    private func setLabelText(follower: String) {
        let string = NSMutableAttributedString()
        let attributedDescription = NSAttributedString(string: "Thanks for the follow, ", attributes: [.foregroundColor: #colorLiteral(red: 0.9019607843, green: 0.8823529412, blue: 0.862745098, alpha: 1)])
        string.append(attributedDescription)

        let attributedFollower = NSAttributedString(string: follower, attributes: [.foregroundColor: #colorLiteral(red: 0.8549019608, green: 0.2862745098, blue: 0.2235294118, alpha: 1)])
        string.append(attributedFollower)

        let attributedExclamation = NSAttributedString(string: "!", attributes: [.foregroundColor: #colorLiteral(red: 0.9019607843, green: 0.8823529412, blue: 0.862745098, alpha: 1)])
        string.append(attributedExclamation)

        string.addAttributes([
            .font: labelFont,
            .paragraphStyle: centeredStyle,
            .shadow: labelShadow
        ], range: NSRange(location: 0, length: string.length))
        label.attributedText = string
    }

    private let labelFont: NSFont = {
        guard let font = NSFontManager.shared.font(withFamily: "Fira Code", traits: .boldFontMask, weight: 0, size: 72) else { fatalError() }
        return font
    }()

    private let centeredStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }()

    private let labelShadow: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.6)
        shadow.shadowOffset = .zero
        shadow.shadowBlurRadius = 20
        return shadow
    }()

    // MARK: Sound

    private let audioPlayer: AVPlayer = {
        guard let soundURL = Bundle.main.url(forResource: "Follow", withExtension: "wav") else { fatalError("Could not find follow sound") }
        let audioPlayer = AVPlayer(url: soundURL)
        audioPlayer.volume = 0.2
        return audioPlayer
    }()

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
