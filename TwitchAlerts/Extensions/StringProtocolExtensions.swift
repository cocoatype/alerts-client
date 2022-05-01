//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

extension StringProtocol where Self: RangeReplaceableCollection {
    func removingPrefix(_ prefix: String) -> Self {
        guard hasPrefix(prefix) else { return self }
        var copy = self
        copy.removeFirst(prefix.count)
        return copy
    }
}
