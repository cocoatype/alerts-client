//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa

class ChatMessageLabel: NSTextField {
    convenience init(message: NSAttributedString) {
        self.init(labelWithAttributedString: message)
        maximumNumberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }

    convenience init(message: String) {
        let attributedString = NSMutableAttributedString(string: message, attributes: [.font: ChatMessageRenderer.font])
        self.init(message: attributedString)
    }
}
