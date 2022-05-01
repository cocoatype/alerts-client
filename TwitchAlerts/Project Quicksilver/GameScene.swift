//
//  GameScene.swift
//  SparksTests
//
//  Created by Geoff Pado on 4/18/21.
//

import AVFoundation
import SpriteKit

class GameScene: SKScene, AVAudioPlayerDelegate {
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?

    func start(for follower: String) {
        setLabelText(follower: follower)

        player.play()
    }

    func reset() {
        player.currentTime = 0
        hasShownLabel = false
        hasStartedShower = false
        cannonBlasts = 0
        label?.removeAllActions()
    }
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
        }

        player.prepareToPlay()
        player.delegate = self
    }

    // MARK: Text

    private let labelTime = TimeInterval(23.18)
    private var hasShownLabel = false

    private func showLabel() {
        label?.run(SKAction.fadeIn(withDuration: 0.5))

        let pulseAction = SKAction(named: "Pulse", duration: 1)!
        let sequence = SKAction.sequence([pulseAction])
        let forever = SKAction.repeatForever(sequence)
        label?.run(forever)
        hasShownLabel = true
    }

    private func setLabelText(follower: String) {
        let string = NSMutableAttributedString()
        let attributedFollower = NSAttributedString(string: follower, attributes: [.foregroundColor: #colorLiteral(red: 0.8549019608, green: 0.2862745098, blue: 0.2235294118, alpha: 1)])
        string.append(attributedFollower)
        let attributedDescription = NSAttributedString(string: "\n100th follower!", attributes: [.foregroundColor: #colorLiteral(red: 0.9019607843, green: 0.8823529412, blue: 0.862745098, alpha: 1)])
        string.append(attributedDescription)
        string.addAttributes([
            .font: labelFont,
            .paragraphStyle: centeredStyle,
            .shadow: labelShadow
        ], range: NSRange(location: 0, length: string.length))
        label?.attributedText = string
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

    // MARK: Cannon

    private func newCannonNode() -> SKEmitterNode {
        guard let node = SKEmitterNode(fileNamed: "Cannon") else { fatalError() }
        return node
    }

    private let cannonColors: [NSColor] = [
        #colorLiteral(red: 0.6470588235, green: 0.7607843137, blue: 0.3803921569, alpha: 1), #colorLiteral(red: 1, green: 0.7764705882, blue: 0.4274509804, alpha: 1), #colorLiteral(red: 0.8549019608, green: 0.2862745098, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0.7137254902, green: 0.7019607843, blue: 0.9215686275, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.6117647059, blue: 0.7450980392, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.8823529412, blue: 0.862745098, alpha: 1)
    ]

    private let cannonTimes: [TimeInterval] = [
        24.70,
        26.00,
        26.87,
        28.70,
        30.38
    ]

    private var cannonBlasts = 0

    private func makeGoBoom() {
        let rightCannon = newCannonNode()
        rightCannon.particleColor = cannonColors[cannonBlasts]
        rightCannon.position = CGPoint(x: size.width / 2, y: size.height / -2)
        rightCannon.emissionAngle = 0.75 * CGFloat.pi
        addChild(rightCannon)

        let leftCannon = newCannonNode()
        leftCannon.particleColor = cannonColors[cannonBlasts]
        leftCannon.position = CGPoint(x: size.width / -2, y: size.height / -2)
        addChild(leftCannon)

        cannonBlasts += 1
    }

    // MARK: Shower

    private func newShowerNode() -> SKEmitterNode {
        guard let node = SKEmitterNode(fileNamed: "Shower") else { fatalError() }
        return node
    }

    private var showerTime = 31.06
    private var hasStartedShower = false

    private func startShower() {
        let shower = newShowerNode()
        shower.position = CGPoint(x: 0, y: size.height / 2)
        shower.particlePositionRange = CGVector(dx: size.width, dy: 0)
//        shower.zPosition = -1
        insertChild(shower, at: 0)
        hasStartedShower = true
    }

    // MARK: Timing

    let player: AVAudioPlayer = {
        do {
            guard let url = Bundle.main.url(forResource: "overture", withExtension: "m4a") else { fatalError("cannot find overture audio")}
            let player = try AVAudioPlayer(contentsOf: url)
            return player
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    override func update(_ currentTime: TimeInterval) {
        guard player.isPlaying else { return }

        if hasShownLabel == false, player.currentTime > labelTime {
            showLabel()
        }

        if cannonBlasts < cannonTimes.count {
            let time = player.currentTime
            let cannonTime = cannonTimes[cannonBlasts]
            if time > cannonTime {
                makeGoBoom()
            }
        } else if hasStartedShower == false, player.currentTime > showerTime {
            startShower()
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        label?.run(SKAction.fadeOut(withDuration: 2.0))
    }
}
