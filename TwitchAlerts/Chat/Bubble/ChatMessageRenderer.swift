//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa
import TwitchChat

enum ChatMessageRenderer {
    static func attributedString(for message: ChatMessage) async -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: message.text, attributes: [
            .font: Self.font
        ])

        let downloadedEmotes = await downloadedEmotes(from: message).sorted(by: { lhs, rhs in
            lhs.range.startIndex > rhs.range.startIndex
        })

        downloadedEmotes.forEach { emote in
            let nsRange = NSRange(location: emote.range.lowerBound, length: emote.range.count)
            attributedString.replaceCharacters(in: nsRange, with: NSAttributedString(attachment: emote.textAttachment))
        }

        return attributedString
    }

    static var font: NSFont {
        if let fontDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body).withDesign(.rounded)?.withSize(22), let roundedFont = NSFont(descriptor: fontDescriptor, textTransform: nil) {
            return roundedFont
        } else {
            return NSFont.preferredFont(forTextStyle: .body).withSize(22)
        }
    }

    private static func downloadedEmotes(from message: ChatMessage) async -> [DownloadedEmote] {
        return await withTaskGroup(of: Optional<DownloadedEmote>.self, returning: [DownloadedEmote].self, body: { group async -> [DownloadedEmote] in
            var downloadedEmotes = [DownloadedEmote]()

            for emote in message.emotes {
                group.addTask {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: emote.imageURL)
                        guard let image = NSImage(data: data) else { throw ChatMessageRenderError.corruptImageData }
                        return DownloadedEmote(image: image, range: emote.range)
                    } catch {
                        return nil
                    }
                }
            }

            for try await downloadedEmote in group {
                guard let downloadedEmote = downloadedEmote else { continue }
                downloadedEmotes.append(downloadedEmote)
            }

            return downloadedEmotes
        })
    }
}

enum ChatMessageRenderError: Error {
    case corruptImageData
}
