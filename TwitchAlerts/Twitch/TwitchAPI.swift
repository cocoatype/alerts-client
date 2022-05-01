//  Created by Geoff Pado on 2/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import Foundation

class TwitchAPIHandler: NSObject, URLSessionWebSocketDelegate {
    override init() {
        super.init()
        startWebSocket()
        startHeartbeat()
    }

    private var accessToken: String?
    private func startWebSocket() {
//        session.webSocketTask(with: Self.urlRequest).resume()
    }

    private func startHeartbeat() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.session.getAllTasks { [weak self] tasks in
                let openTasks = tasks.compactMap { $0 as? URLSessionWebSocketTask }.filter { $0.closeCode == .invalid }
                guard openTasks.isEmpty else { return }
                self?.startWebSocket()
            }
        }
    }

    // MARK: Socket Handling

    private func readMessage(from task: URLSessionWebSocketTask) {
        task.receive { [weak self, weak task] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data): self?.readDataMessage(data)
                case .string(let string): self?.readStringMessage(string)
                @unknown default: break
                }

                if let task = task { self?.readMessage(from: task) }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }

    private func readDataMessage(_ data: Data) {
        print(data.map { String(format: "%02hhx", $0) }.joined())
        do {
            let decodedMessage = try JSONDecoder().decode(TwitchFollowEvent.self, from: data)
            publisher.send(decodedMessage)
        } catch {}
    }

    private func readStringMessage(_ string: String) {
        print(string)
        if let data = string.data(using: .utf8) {
            readDataMessage(data)
        }
    }

    let publisher = PassthroughSubject<TwitchFollowEvent, Never>()

    // MARK: Web Socket Delegate

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        readMessage(from: webSocketTask)
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("web socket closed with code: \(closeCode)")
        startWebSocket()
    }

    // MARK: Boilerplate

    private lazy var session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

    private static let urlRequest: URLRequest = {
        URLRequest(url: Constants.websocketsURL)
    }()
}
