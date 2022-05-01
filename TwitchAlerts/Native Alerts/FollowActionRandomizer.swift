//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SpriteKit

class FollowActionRandomizer: NSObject {
    static func randomAction() -> SKAction {
        wrappedAction(with: allActions.shuffled()[0])
    }

    private static let allActions = [
        PulseActionFactory.pulseAction(),
        WiggleActionFactory.wiggleAction()
    ]

    static func wrappedAction(with action: SKAction) -> SKAction {
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        return SKAction.sequence([fadeInAction, action, fadeOutAction])
    }
}
