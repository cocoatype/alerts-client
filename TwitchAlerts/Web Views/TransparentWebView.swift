//  Created by Geoff Pado on 2/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import WebKit

class TransparentWebView: WKWebView {
    init() {
        let configuration = WKWebViewConfiguration()
        configuration.mediaTypesRequiringUserActionForPlayback = []
        super.init(frame: .zero, configuration: configuration)
        translatesAutoresizingMaskIntoConstraints = false

        setValue(true, forKey: "drawsTransparentBackground")
    }

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        load(urlRequest)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

    var urlRequest: URLRequest { URLRequest(url: Constants.alertBoxURL) }
}
