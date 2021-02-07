//
// Created by yangentao on 2021/2/7.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public class ImageLabelView: UIView {
    public private(set) lazy var imageView: UIImageView = NamedView(self, "imageView")
    public private(set) lazy var labelView: UILabel = NamedView(self, "labelView")
    public private(set) var configVer: ConfigVer = ConfigVer()

    @discardableResult
    public func buildVer(_ block: (ConfigVer) -> Void) -> Self {
        block(configVer)
        buildVer()
        return self
    }

    @discardableResult
    public func buildVer() -> Self {
        buildViews {
            UIImageView.Default.named("imageView").contMode(.scaleAspectFill).roundLayer(6).constraints { p in
                p.centerXParent().topParent(configVer.topOffset)
                p.bottom.eq("labelView", otherAttr: .top, constant: -configVer.midSpace).ident("spaceIdent")
                p.widthRatio(multi: 1)
            }
            UILabel.Minor.named("labelView").align(.center).lines(0).clipsToBounds(false).constraints { p in
                p.centerXParent()
                p.height(configVer.labelHeight).priority(.defaultHigh)
                p.top.eqParent(otherAttr: .bottom, constant: -configVer.labelHeight - configVer.bottomOffset)
//                p.bottomParent(-config.bottomOffset)
                p.width.leParent(constant: -20)
                p.width.geConst(configVer.labelMinWidth)
            }.keepContent(.vertical)
        }
        self.roundLayer(6)
        self.clipsToBounds = false

        return self
    }

    public class ConfigVer {
        var topOffset: CGFloat = 0
        var bottomOffset: CGFloat = 0
        var midSpace: CGFloat = 0
        var labelHeight: CGFloat = 26
        var labelMinWidth: CGFloat = 30

    }
}