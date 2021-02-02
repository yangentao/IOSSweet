//
// Created by entaoyang on 2019-02-12.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

//layoutparam.height 不支持matchparent 和wrapcontent
public class VerticalLayout {
    public unowned var view: UIView

    private var childViews = [UIView]()

    public var edge: Edge = Edge()

    public var defaultHeight: CGFloat = 60

    public init(_ v: UIView) {
        self.view = v
    }
}

public extension VerticalLayout {

    var count: Int {
        return self.childViews.count
    }

    func edges(_ all: CGFloat) {
        self.edge(l: all, t: all, r: all, b: all)
    }

    func edge(l: CGFloat, t: CGFloat, r: CGFloat, b: CGFloat) {
        self.edge.left = l
        self.edge.top = t
        self.edge.right = r
        self.edge.bottom = b
    }

    @discardableResult
    func add(_ v: UIView, _ height: CGFloat) -> LinearParam {
        childViews.append(v)
        v.linearParamEnsure.height(height)
        return v.linearParamEnsure
    }

    @discardableResult
    func add(_ v: UIView) -> LinearParam {
        childViews.append(v)
        return v.linearParamEnsure
    }

    var totalHeight: CGFloat {
        return self.childViews.sumBy({
            $0.marginTop + $0.marginBottom + ($0.linearParamEnsure.height > 0 ? $0.linearParamEnsure.height : self.defaultHeight)
        }) + self.edge.top + self.edge.bottom
    }

    func install(_ isScrollContentView: Bool = false) {
        let weightSum: CGFloat = self.childViews.sumBy {
            $0.linearParamEnsure.weight
        }
        for n in childViews.indices {
            let v = childViews[n]
            self.view.addSubview(v)

            let L = v.layout
            let p = v.linearParamEnsure
            if p.height < 0 {
                //不支持matchparent 和wrapcontent
                p.height = defaultHeight
                loge("不支持MatchParent 和WrapContent")
            }
            if p.width > 0 {
                L.width(p.width)
                switch p.gravityX {
                case .right:
                    L.rightParent(-v.marginRight - edge.right)
                case .center:
                    L.centerXParent()
                default:
                    L.leftParent(v.marginLeft + edge.left)
                }
            } else {
                L.leftParent(v.marginLeft + edge.left).rightParent(-v.marginRight - edge.right)
            }

            if p.height > 0 {
                L.height(p.height)
            } else if p.height == 0 && p.weight > 0 && !isScrollContentView {
                //allspace = parent.height  -  (all.mt + all.mb + all.height + edge.top + edge.bottom)
                //myheight = allspace * myWeight / weightSum
                let fixY = self.edge.top + self.edge.bottom + self.childViews.sumBy {
                    $0.linearParamEnsure.height + $0.marginTop + $0.marginBottom
                }
                // myheight = parent.height * myWeight / weightSum - fixY * myWeight / weightSum
                let percent = p.weight / weightSum
                L.height.eqParent.multi(percent).constant(-fixY * percent).active()
            } else {
                L.height(self.defaultHeight)
                loge("高度没有被正确设置, height >0 或者 height==0 && weight>0, 在ScrollView中不能设置weight且height>0")
            }

            if n == 0 {
                L.topParent(v.marginTop + edge.top)
            } else {
                let preView: UIView = childViews[n - 1]
                L.below(preView, v.marginTop + preView.marginBottom)
            }
        }
        if isScrollContentView {
            if let v = self.childViews.last {
                v.layout.bottomParent(-v.marginBottom - self.edge.bottom)
            }
        }
    }

}

public extension UIView {
    var layoutVertical: VerticalLayout {
        return VerticalLayout(self)
    }

    @discardableResult
    func layoutVertical(_ block: (VerticalLayout) -> Void) -> CGFloat {
        let L = self.layoutVertical
        block(L)
        L.install()
        return L.totalHeight
    }

}