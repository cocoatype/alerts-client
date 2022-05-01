//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa

class ChatBubbleBackground: NSVisualEffectView {
    init() {
        super.init(frame: .zero)
        material = .underWindowBackground
        state = .active
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true

        layer?.cornerRadius = 16
        layer?.cornerCurve = .continuous
        layer?.masksToBounds = true
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
