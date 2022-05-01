//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Foundation

@propertyWrapper
public struct EnvironmentVariable {
    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: String {
        guard let value = ProcessInfo.processInfo.environment[key] else {
            fatalError("Missing environment variable: \(key)")
        }
        return value
    }

    private let key: String
}
