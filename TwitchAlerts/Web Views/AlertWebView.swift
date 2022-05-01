//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Foundation

class AlertWebView: TransparentWebView {
    override var urlRequest: URLRequest { URLRequest(url: Constants.alertBoxURL) }
}
