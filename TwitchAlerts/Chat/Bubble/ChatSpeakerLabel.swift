//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa

class ChatSpeakerLabel: NSTextField {
    convenience init(name: String, color: NSColor) {
        self.init(labelWithString: name)
        if let fontDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .headline).withDesign(.rounded)?.withSize(22) {
            font = NSFont(descriptor: fontDescriptor, textTransform: nil)
        }
        textColor = color
        translatesAutoresizingMaskIntoConstraints = false
    }
}
