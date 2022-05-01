//  Created by Geoff Pado on 2/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import Cocoa

class AlertViewController: NSViewController {
    override func loadView() {
        view = alertView
        preferredContentSize = CGSize(width: 640, height: 480)
    }

    var devices: [Device] { alertView.devices }

    private lazy var alertView = AlertView(apiPublisher: apiHandler.publisher.eraseToAnyPublisher())
    private let apiHandler = TwitchAPIHandler()
    private var cancellables = Set<AnyCancellable>()
}
