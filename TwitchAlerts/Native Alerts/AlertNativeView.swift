//  Created by Geoff Pado on 6/4/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import AppKit
import AVFoundation
import Combine
import SpriteKit

class AlertNativeView: NSView {
    init(apiPublisher: AnyPublisher<TwitchFollowEvent, Never>) {
        super.init(frame: .zero)
        wantsLayer = true
        translatesAutoresizingMaskIntoConstraints = false

        apiPublisher.receive(on: RunLoop.main).sink { [weak self] followEvent in
            self?.sceneView.start(with: followEvent.follower)
        }.store(in: &cancellables)

        addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: topAnchor),
            sceneView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sceneView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

    private let sceneView = FollowerSceneView()
    private var cancellables = Set<AnyCancellable>()
}
