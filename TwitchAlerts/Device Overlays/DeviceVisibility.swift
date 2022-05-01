//  Created by Geoff Pado on 6/4/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

extension Device {
    enum Visibility {
        case pip, fullscreen, hidden

        init?(code: OSType) {
            let string = code.string
            switch string {
            case "PIP ": self = .pip
            case "Full": self = .fullscreen
            case "Hide": self = .hidden
            default: return nil
            }
        }

        var code: OSType {
            let string: String
            switch(self) {
            case .pip: string = "PIP "
            case .fullscreen: string = "Full"
            case .hidden: string = "Hide"
            }
            return string.utf16.reduce(0, {$0 << 8 + FourCharCode($1)})
        }
    }
}
