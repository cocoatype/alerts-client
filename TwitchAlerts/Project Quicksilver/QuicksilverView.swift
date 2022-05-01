//  Created by Geoff Pado on 4/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SpriteKit

class QuicksilverView: SKView {
    init() {
        super.init(frame: .zero)
        allowsTransparency = true
        translatesAutoresizingMaskIntoConstraints = false

        if let scene = SKScene(fileNamed: "GameScene") {
            scene.backgroundColor = .clear
            scene.scaleMode = .aspectFill
            presentScene(scene)
        }

        ignoresSiblingOrder = true
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
