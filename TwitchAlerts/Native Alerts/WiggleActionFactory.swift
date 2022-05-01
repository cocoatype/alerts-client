//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SpriteKit

class WiggleActionFactory: NSObject {
    class func wiggleAction() -> SKAction {
        return SKAction.animate(withWarps: warpGeometries, times: warpTimes, restore: true)!
    }

    private static let warpGeometries: [SKWarpGeometry] = {
        let natural = SKWarpGeometryGrid(columns: 5, rows: 1)
        let positiveWarp = SKWarpGeometryGrid(columns: 5, rows: 1,
                                                destinationPositions:
                                                    [
                                                        SIMD2<Float>(0,-0.1),
                                                        SIMD2<Float>(0.2,0.1),
                                                        SIMD2<Float>(0.4,-0.1),
                                                        SIMD2<Float>(0.6,0.1),
                                                        SIMD2<Float>(0.8,-0.1),
                                                        SIMD2<Float>(1,0.1),
                                                        SIMD2<Float>(0,0.9),
                                                        SIMD2<Float>(0.2,1.1),
                                                        SIMD2<Float>(0.4,0.9),
                                                        SIMD2<Float>(0.6,1.1),
                                                        SIMD2<Float>(0.8,0.9),
                                                        SIMD2<Float>(1,1.1)
                                                    ])
        let negativeWarp = SKWarpGeometryGrid(columns: 5, rows: 1,
                                                destinationPositions:
                                                    [
                                                        SIMD2<Float>(0,0.1),
                                                        SIMD2<Float>(0.2,-0.1),
                                                        SIMD2<Float>(0.4,0.1),
                                                        SIMD2<Float>(0.6,-0.1),
                                                        SIMD2<Float>(0.8,0.1),
                                                        SIMD2<Float>(1,-0.1),
                                                        SIMD2<Float>(0,1.1),
                                                        SIMD2<Float>(0.2,0.9),
                                                        SIMD2<Float>(0.4,1.1),
                                                        SIMD2<Float>(0.6,0.9),
                                                        SIMD2<Float>(0.8,1.1),
                                                        SIMD2<Float>(1,0.9)
                                                    ])
        return [natural, positiveWarp, negativeWarp, positiveWarp, negativeWarp, positiveWarp, negativeWarp, natural]
    }()

    private static let warpTimes: [NSNumber] = [
        NSNumber(value: 0),
        NSNumber(value: 3.3/7.0 * 1.0),
        NSNumber(value: 3.3/7.0 * 2.0),
        NSNumber(value: 3.3/7.0 * 3.0),
        NSNumber(value: 3.3/7.0 * 4.0),
        NSNumber(value: 3.3/7.0 * 5.0),
        NSNumber(value: 3.3/7.0 * 6.0),
        NSNumber(value: 3.3/7.0 * 7.0)
    ]
}
