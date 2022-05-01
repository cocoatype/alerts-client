//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa
import TwitchChat

class ChatViewController: NSViewController {
    init(message: ChatMessage) async {
        chatView = await ChatView(message: message)
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = chatView
        preferredContentSize = CGSize(width: 320, height: 64)
    }

    private let chatView: ChatView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
