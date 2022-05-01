//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SpriteKit

class FollowerSceneView: SKView {
    init() {
        super.init(frame: .zero)
        allowsTransparency = true
        translatesAutoresizingMaskIntoConstraints = false
        presentScene(followerScene)
    }

    func start(with follower: String) {
        followerScene.start(for: follower)
    }

    private let followerScene = FollowerScene(size: CGSize(width: 2560, height: 1440))

    override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        guard let superview = superview else { return }
//        followerScene.size = superview.bounds.size
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
