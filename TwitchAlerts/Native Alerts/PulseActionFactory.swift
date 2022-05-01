//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SpriteKit

class PulseActionFactory: NSObject {
    class func pulseAction() -> SKAction {
        return SKAction(named: "Follow")!
    }
}
