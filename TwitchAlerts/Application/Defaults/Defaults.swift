//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Foundation

enum Defaults {
    @Value(key: .chatRefreshToken, fallback: "") public static var chatRefreshToken: String
}
