//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa

extension NSColor {
    convenience init(hexLiteral hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0x00FF00) >> 8)
        let blue = CGFloat((hex & 0x0000FF) >> 0)

        self.init(red: red / 255,
                  green: green / 255,
                  blue: blue / 255,
                  alpha: 1.0)
    }

    convenience init?(hexString: String) {
        guard let int = Int(hexString.removingPrefix("#"), radix: 16) else { return nil }
        self.init(hexLiteral: int)
    }
}
