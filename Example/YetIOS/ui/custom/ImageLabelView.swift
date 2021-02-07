//
// Created by yangentao on 2021/2/7.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public class ImageLabelView: UIView {
    public private(set) lazy var imageView: UIImageView = NamedView(self, "imageView")
    public private(set) lazy var labelView: UILabel = NamedView(self, "labelView")


    @discardableResult
    public func vertical(margins: Edge = Edge(left: 0, top: 2, right: 0, bottom: 1), space: CGFloat = 2) -> Self {
        buildViews {
            UIImageView.Default.named("imageView").contMode(.scaleAspectFill).roundLayer(6).constraints { p in
                p.centerXParent()
                p.topParent(margins.top)
                p.bottom.eq("labelView", otherAttr: .top, constant: -space).ident("spaceIdent")
                p.widthRatio(multi: 1)
            }
            UILabel.Minor.named("labelView").align(.center).lines(0).clipsToBounds(false).constraints { p in
                p.centerXParent()
                p.height(26).priority(.defaultHigh)
                p.top.eqParent(otherAttr: .bottom, constant: -26 - margins.bottom)
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
    public func horizontal(margins: Edge = Edge(left: 12, top: 8, right: 16, bottom: 8), space: CGFloat = 8) -> Self {
        buildViews {
            UIImageView.Default.named("imageView").contMode(.scaleAspectFill).constraints { p in
                p.edgeYParent(topConst: margins.top, bottomConst: -margins.bottom)
                p.leftParent(margins.left)
                p.widthRatio(multi: 1)
            }
            UILabel.Primary.named("labelView").align(.left).lines(0).clipsToBounds(false).constraints { p in
                p.edgeYParent(topConst: margins.top, bottomConst: -margins.bottom)
                p.left.eq("imageView", otherAttr: .right, constant: space)
                p.rightParent(-margins.right)
            }//.keepContent(.vertical)
        }
        self.clipsToBounds = true
        return self
    }


}