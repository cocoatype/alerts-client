//  Created by Geoff Pado on 2/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

enum Constants {
    @EnvironmentVariable("ALERT_BOX_URL") private static var alertBoxURLString
    static let alertBoxURL: URL = {
        guard let url = URL(string: alertBoxURLString) else {
            fatalError("Tried to generate invalid URL")
        }

        return url
    }()

    static let websocketsURL: URL = {
        guard let url = URL(string: "ws://127.0.0.1:8080/client") else {
            fatalError("Tried to generate invalid URL")
        }

        return url
    }()
}
