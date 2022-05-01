//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Foundation
import TwitchChat

struct ChatClient {
    init(name: String) {
        self.name = name
    }

    func start() async throws {
        let token = try await OAuthRefresher.newAccessToken()
        Task.detached {
            let chat = TwitchChat(token: token, name: name)
            for try await message in chat.messages {
                guard ignoredChatters.contains(message.sender) == false else { continue }
                let windowController = await ChatWindowController(message: message)
                await MainActor.run {
                    windowController.displayWindow()
                }
            }
        }
    }

    private let ignoredChatters = ["Nightbot"]

    private let name: String
}
