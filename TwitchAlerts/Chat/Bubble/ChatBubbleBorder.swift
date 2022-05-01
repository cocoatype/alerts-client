//  Created by Geoff Pado on 4/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Cocoa

class ChatBubbleBorder: NSView, CALayerDelegate {
    init() {
        self.cornerRadius = 16
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true

        layer?.delegate = self
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        guard let layer = layer else { return }
        layer.addSublayer(InnerBorderLayer())
        layer.addSublayer(OuterBorderLayer())
        layoutSublayers(of: layer)
    }

    func layoutSublayers(of layer: CALayer) {
        layer.sublayers?.forEach { sublayer in
            sublayer.frame = layer.bounds
            sublayer.contentsScale = layer.contentsScale
        }
    }

    override func layout() {
        super.layout()
        guard let layer = layer else { return }
        layer.frame = bounds
        layoutSublayers(of: layer)
    }

    class InnerBorderLayer: CALayer {
        override init() {
            super.init()
            self.cornerRadius = 16
            self.borderWidth = 1
            self.borderColor = CGColor(gray: 1, alpha: 0.22)
        }

        override init(layer: Any) {
            super.init(layer: layer)
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            let typeName = NSStringFromClass(type(of: self))
            fatalError("\(typeName) does not implement init(coder:)")
        }
    }

    class OuterBorderLayer: CALayer {
        override init() {
            super.init()
            self.cornerRadius = 16
            self.borderWidth = 1.0 / contentsScale
            self.borderColor = CGColor(gray: 0, alpha: 0.8)
        }

        override var contentsScale: CGFloat {
            didSet {
                self.borderWidth = 1.0 / contentsScale
            }
        }

        override init(layer: Any) {
            super.init(layer: layer)
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            let typeName = NSStringFromClass(type(of: self))
            fatalError("\(typeName) does not implement init(coder:)")
        }
    }

    // MARK: Boilerplate

    private let cornerRadius: CGFloat

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
