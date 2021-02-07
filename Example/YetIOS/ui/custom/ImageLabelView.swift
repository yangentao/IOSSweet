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
    public private(set) var configHor: Edge = Edge().hor(10).ver(8)
    public var space: CGFloat = -1

    public func space(_ n: CGFloat) -> Self {
        space = n
        return self
    }

    @discardableResult
    public func vertical(_ block: (ConfigVer) -> Void) -> Self {
        block(configVer)
        vertical()
        return self
    }

    @discardableResult
    public func vertical() -> Self {
        if space < 0 {
            space = 2
        }
        buildViews {
            UIImageView.Default.named("imageView").contMode(.scaleAspectFill).roundLayer(6).constraints { p in
                p.centerXParent()
                p.topParent(configVer.topOffset)
                p.bottom.eq("labelView", otherAttr: .top, constant: -space).ident("spaceIdent")
                p.widthRatio(multi: 1)
            }
            UILabel.Minor.named("labelView").align(.center).lines(0).clipsToBounds(false).constraints { p in
                p.centerXParent()
                p.height(configVer.labelHeight).priority(.defaultHigh)
                p.top.eqParent(otherAttr: .bottom, constant: -configVer.labelHeight - configVer.bottomOffset)
//                p.bottomParent(-config.bottomOffset)
                p.width.leParent(constant: -20)
                p.width.geConst(30)
            }.keepContent(.vertical)
        }
        self.roundLayer(6)
        self.clipsToBounds = false

        return self
    }

    @discardableResult
    public func horizontal() -> Self {
        if space < 0 {
            space = 8
        }
        buildViews {
            UIImageView.Default.named("imageView").contMode(.scaleAspectFill).constraints { p in
                p.edgeYParent(topConst: configHor.top, bottomConst: -configHor.bottom)
                p.leftParent(configHor.left)
//                p.centerYParent()
//                p.heightParent(constant: -configHor.top - configHor.bottom)
                p.widthRatio(multi: 1)
            }
            UILabel.Primary.named("labelView").align(.left).lines(0).clipsToBounds(false).constraints { p in
                p.edgeYParent(topConst: configHor.top, bottomConst: -configHor.bottom)
                p.left.eq("imageView", otherAttr: .right, constant: space)
                p.rightParent(-configHor.right)
            }//.keepContent(.vertical)
        }
        self.clipsToBounds = true
        return self
    }


    public class ConfigVer {
        var topOffset: CGFloat = 0
        var bottomOffset: CGFloat = 0
        var labelHeight: CGFloat = 26
    }
}