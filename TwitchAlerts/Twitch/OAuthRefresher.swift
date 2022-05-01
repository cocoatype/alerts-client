//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Foundation

enum OAuthRefresher {
    @EnvironmentVariable("CHAT_REFRESH_TOKEN") private static var token
    @EnvironmentVariable("APP_CLIENT_ID") private static var clientID
    @EnvironmentVariable("APP_CLIENT_SECRET") private static var clientSecret

    static func newAccessToken() async throws -> String {
        let (data, _) = try await URLSession.shared.data(for: refreshRequest)
        let response = try OAuthDecoder().decode(OAuthResponse.self, from: data)
        return response.accessToken
    }

    private static var refreshRequest: URLRequest {
        get throws {
            var request = try URLRequest(url: refreshEndpoint)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = "grant_type=refresh_token&refresh_token=\(token)&client_id=\(clientID)&client_secret=\(clientSecret)"
                .data(using: .utf8)
            return request
        }
    }

    private static var refreshEndpoint: URL {
        get throws {
            guard let url = URL(string: "https://id.twitch.tv/oauth2/token") else { throw OAuthRefreshError.invalidURL }
            return url
        }
    }
}

enum OAuthRefreshError: Error {
    case invalidURL
}
