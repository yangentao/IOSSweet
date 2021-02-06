//
// Created by yangentao on 2021/2/1.
//

import Foundation
import UIKit


public extension UIView {
    var linearParams: LinearParams? {
        get {
            return getAttr("__linearParam__") as? LinearParams
        }
        set {
            setAttr("__linearParam__", newValue)
        }
    }

    var linearParamEnsure: LinearParams {
        if let L = self.linearParams {
            return L
        } else {
            let a = LinearParams()
            self.linearParams = a
            return a
        }
    }

    @discardableResult
    func linearParams(_ width: CGFloat, _ height: CGFloat) -> LinearParams {
        return linearParamEnsure.width(width).height(height)
    }

    @discardableResult
    func linearParams(_ block: (LinearParams) -> Void) -> Self {
        block(linearParamEnsure)
        return self
    }
}

public extension LinearLayout {
    @discardableResult
    func appendChild<T: UIView>(_ view: T, _ width: CGFloat, _ height: CGFloat) -> T {
        view.linearParamEnsure.width(width).height(height)
        addSubview(view)
        return view
    }
}

public class LinearParams {

    public var width: CGFloat = 0
    public var height: CGFloat = 0

    @GreatEQ(minValue: 0)
    public var weight: CGFloat = 0

    public var gravityX: GravityX = .none
    public var gravityY: GravityY = .none

    @GreatEQ(minValue: 0)
    public var minWidth: CGFloat = 0
    @GreatEQ(minValue: 0)
    public var minHeight: CGFloat = 0

    @GreatEQ(minValue: 0)
    public var maxWidth: CGFloat = 0
    @GreatEQ(minValue: 0)
    public var maxHeight: CGFloat = 0
}

public extension LinearParams {

    @discardableResult
    func minWidth(_ n: CGFloat) -> Self {
        self.minWidth = n
        return self
    }

    @discardableResult
    func maxWidth(_ n: CGFloat) -> Self {
        self.maxWidth = n
        return self
    }

    @discardableResult
    func minHeight(_ n: CGFloat) -> Self {
        self.minHeight = n
        return self
    }

    @discardableResult
    func maxHeight(_ n: CGFloat) -> Self {
        self.maxHeight = n
        return self
    }

    @discardableResult
    func widthFill() -> Self {
        self.width = MatchParent
        return self
    }

    @discardableResult
    func widthWrap() -> Self {
        self.width = WrapContent
        return self
    }

    @discardableResult
    func heightFill() -> Self {
        self.height = MatchParent
        return self
    }

    @discardableResult
    func heightWrap() -> Self {
        self.height = WrapContent
        return self
    }

    @discardableResult
    func width(_ w: CGFloat) -> Self {
        self.width = w
        return self
    }

    @discardableResult
    func height(_ h: CGFloat) -> Self {
        self.height = h
        return self
    }

    @discardableResult
    func weight(_ w: CGFloat) -> Self {
        self.weight = w
        return self
    }

    @discardableResult
    func gravityX(_ g: GravityX) -> Self {
        self.gravityX = g
        return self
    }

    @discardableResult
    func gravityY(_ g: GravityY) -> Self {
        self.gravityY = g
        return self
    }

}


public class LinearLayout: UIView {
    public var axis: LayoutAxis = .vertical
    public var padding: Edge = Edge()

    private var contentSize: CGSize = .zero {
        didSet {
            if oldValue != contentSize {
                processScroll()
            }
        }
    }

    convenience init(_ axis: LayoutAxis) {
        self.init(frame: .zero)
        self.axis = axis
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        processScroll()
    }

    private func processScroll() {
        if let pv = self.superview as? UIScrollView {
            pv.contentSize = contentSize
        }
    }

    @discardableResult
    public func axis(_ ax: LayoutAxis) -> Self {
        self.axis = ax
        return self
    }

    public func paddings(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> Self {
        padding = Edge(left: left, top: top, right: right, bottom: bottom)
        return self
    }

    public var heightSumFixed: CGFloat {
        let ls = self.subviews
        var total: CGFloat = 0
        for v in ls {
            if let p = v.linearParams {
                if p.height > 0 {
                    total += p.height
                } else if p.minHeight > 0 {
                    total += p.minHeight
                }
            }
        }
        return total
    }

    public override func layoutSubviews() {
        if self.subviews.count == 0 {
            return
        }
        let tmpBounds = bounds
        var sz = tmpBounds.size
        sz.width -= padding.left + padding.right
        sz.height -= padding.top + padding.bottom
        if axis == .vertical {
            let ls = calcSizesVertical(sz)
            let maxY = layoutChildrenVertical(ls)
            contentSize = CGSize(width: tmpBounds.size.width, height: max(0, maxY - tmpBounds.minY))
        } else {
            let ls = calcSizesHor(sz)
            let maxX = layoutChildrenHor(ls)
            contentSize = CGSize(width: max(0, maxX - tmpBounds.minX), height: tmpBounds.size.height)
        }
    }

    private func calcSizesHor(_ size: CGSize) -> [CGSize] {
        let childViewList = subviews
        let childCount = childViewList.count

        let unspec: CGFloat = -1
        let totalWidth = size.width
        var avaliableWidth = totalWidth

        var matchSum = 0
        var weightSum: CGFloat = 0

        var szList = [CGSize](repeating: CGSize(width: unspec, height: unspec), count: childViewList.count)
        for (index, chView) in childViewList.enumerated() {
            guard  let param = chView.linearParams else {
                szList[index] = Size(width: 0, height: 0)
                continue
            }
            avaliableWidth -= chView.marginLeft + chView.marginRight
            if param.width == MatchParent {
                matchSum += 1
                avaliableWidth -= param.minWidth
            } else if param.width == WrapContent {
                let sz = chView.sizeThatFits(size)
                szList[index].width = max(0, sz.width)
                avaliableWidth -= szList[index].width
            } else if param.width > 0 {
                szList[index].width = max(0, param.width)
                avaliableWidth -= szList[index].width
            } else if param.width == 0 {
                if param.weight > 0 {
                    weightSum += param.weight
                    avaliableWidth -= param.minWidth
                } else {
                    szList[index].width = 0
                }

            } else {
                fatalError("LinearParam.height < 0 ")
            }
        }
        if matchSum > 0 && weightSum > 0 {
            fatalError("LinearParam error , Can not use MatchParent and weight in same time!")
        }
        var unspecIndexList: [Int] = []
        for i in 0..<childCount {
            if szList[i].width == unspec {
                unspecIndexList.append(i)
            }
        }
        //每个先分配最小值
        for i in unspecIndexList {
            let pm = childViewList[i].linearParamEnsure
            szList[i].width = pm.minWidth
        }
        if matchSum > 0 {
            let w = max(0, avaliableWidth) / matchSum
            //先处理最大值小于平均值的
            var useMaxWidthList: [Int] = []
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                if pm.maxWidth > 0 {
                    if pm.maxWidth < w {
                        szList[i].width = pm.maxWidth
                        useMaxWidthList.append(i)
                        avaliableWidth -= pm.maxWidth
                    }
                }
            }
            unspecIndexList.removeAll(useMaxWidthList)
            //剩下的全是没有设置最大值, 或最大值大于平均值的情况
            let ww = max(0, avaliableWidth) / max(1, matchSum - useMaxWidthList.count)
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                szList[i].width = pm.minWidth + ww
            }
        }
        if weightSum > 0 {
            let a = max(0, avaliableWidth) / weightSum
            //先处理最大值小于平均值的
            var useMaxValueList: [Int] = []
            var fixedWeightSum: CGFloat = 0
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                if pm.maxWidth > 0 {
                    if pm.maxWidth < pm.weight * a {
                        fixedWeightSum += pm.weight
                        szList[i].width = pm.maxWidth
                        useMaxValueList.append(i)
                        avaliableWidth -= pm.maxWidth
                    }
                }
            }
            unspecIndexList.removeAll(useMaxValueList)
            //剩下的全是没有设置最大值, 或最大值大于平均值的情况
            let aa = max(0, avaliableWidth) / max(1, weightSum - fixedWeightSum)
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                szList[i].width = pm.minWidth + aa * pm.weight
            }
        }
        return szList
    }

    private func layoutChildrenHor(_ sizeList: [CGSize]) -> CGFloat {
        let childViewList = subviews

        let boundsSize = bounds.size
        let totalHeight: CGFloat = boundsSize.height - padding.top - padding.bottom
        var fromX = bounds.origin.x + padding.left
        for (index, chView) in childViewList.enumerated() {
            let xx = fromX + chView.marginLeft
            let ww = sizeList[index].width
            var hh: CGFloat = -1
            let param = chView.linearParams!

            if param.height == MatchParent || param.gravityY == .fill {
                hh = totalHeight - chView.marginTop - chView.marginBottom
            } else if param.height >= 0 {
                hh = param.height
            } else if param.height == WrapContent {
                let sz = chView.sizeThatFits(Size(width: ww, height: totalHeight))
                hh = sz.height
            } else {
                hh = 0
            }
            hh = max(0, hh)

            var yy: CGFloat = bounds.origin.y + padding.top + chView.marginTop
            if param.height != MatchParent {
                switch chView.linearParams!.gravityY {
                case .none, .top, .fill:
                    break
                case .bottom:
                    yy = bounds.maxY - padding.bottom - chView.marginBottom - hh
                case .center:
                    yy = bounds.origin.y + padding.top + (totalHeight - hh) / 2
                    break
                }
            }

            let r = Rect(x: xx, y: yy, width: ww, height: hh)
            chView.frame = r
            fromX += chView.marginLeft + ww + chView.marginRight
        }
        fromX += padding.right
        return fromX

    }


    //=========

    private func calcSizesVertical(_ size: CGSize) -> [CGSize] {
        let childViewList = subviews
        let childCount = childViewList.count

        let unspec: CGFloat = -1
        let totalHeight = size.height
        var avaliableHeight = totalHeight

        var matchSum = 0
        var weightSum: CGFloat = 0

        var szList = [CGSize](repeating: CGSize(width: unspec, height: unspec), count: childViewList.count)
        for (index, chView) in childViewList.enumerated() {
            guard  let param = chView.linearParams else {
                szList[index] = Size(width: 0, height: 0)
                continue
            }
            avaliableHeight -= chView.marginTop + chView.marginBottom
            if param.height == MatchParent {
                matchSum += 1
                avaliableHeight -= param.minHeight
            } else if param.height == WrapContent {
                let sz = chView.sizeThatFits(size)
                szList[index].height = max(0, sz.height)
                avaliableHeight -= szList[index].height
            } else if param.height > 0 {
                szList[index].height = max(0, param.height)
                avaliableHeight -= szList[index].height
            } else if param.height == 0 {
                if param.weight > 0 {
                    weightSum += param.weight
                    avaliableHeight -= param.minHeight
                } else {
                    szList[index].height = 0
                }

            } else {
                fatalError("LinearParam.height < 0 ")
            }
        }
        if matchSum > 0 && weightSum > 0 {
            fatalError("LinearParam error , Can not use MatchParent and weight in same time!")
        }

        var unspecIndexList: [Int] = []
        for i in 0..<childCount {
            if szList[i].height == unspec {
                unspecIndexList.append(i)
            }
        }
        //每个先分配最小值
        for i in unspecIndexList {
            let pm = childViewList[i].linearParamEnsure
            szList[i].height = pm.minHeight
        }


        if matchSum > 0 {
            let h = max(0, avaliableHeight) / matchSum
            //先处理最大值小于平均值的
            var useMaxWidthList: [Int] = []
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                if pm.maxHeight > 0 {
                    if pm.maxHeight < h {
                        szList[i].height = pm.maxHeight
                        useMaxWidthList.append(i)
                        avaliableHeight -= pm.maxHeight
                    }
                }
            }
            unspecIndexList.removeAll(useMaxWidthList)
            //剩下的全是没有设置最大值, 或最大值大于平均值的情况
            let hh = max(0, avaliableHeight) / max(1, matchSum - useMaxWidthList.count)
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                szList[i].height = pm.minHeight + hh
            }
        }
        if weightSum > 0 {
            let a = max(0, avaliableHeight) / weightSum
            //先处理最大值小于平均值的
            var useMaxValueList: [Int] = []
            var fixedWeightSum: CGFloat = 0
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                if pm.maxHeight > 0 {
                    if pm.maxHeight < pm.weight * a {
                        fixedWeightSum += pm.weight
                        szList[i].height = pm.maxHeight
                        useMaxValueList.append(i)
                        avaliableHeight -= pm.maxHeight
                    }
                }
            }
            unspecIndexList.removeAll(useMaxValueList)
            //剩下的全是没有设置最大值, 或最大值大于平均值的情况
            let aa = max(0, avaliableHeight) / max(1, weightSum - fixedWeightSum)
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                szList[i].height = pm.minHeight + aa * pm.weight
            }
        }
        return szList
    }

    private func layoutChildrenVertical(_ sizeList: [CGSize]) -> CGFloat {
        let childViewList = subviews

        let boundsSize = bounds.size
        let totalWidth: CGFloat = boundsSize.width - padding.left - padding.right
        var fromY = bounds.origin.y + padding.top
        for (index, chView) in childViewList.enumerated() {
            let y = fromY + chView.marginTop
            let h = sizeList[index].height
            var w: CGFloat = -1
            let param = chView.linearParams!

            if param.width == MatchParent || param.gravityX == .fill {
                w = totalWidth - chView.marginLeft - chView.marginRight
            } else if param.width >= 0 {
                w = param.width
            } else if param.width == WrapContent {
                let sz = chView.sizeThatFits(Size(width: totalWidth, height: h))
                w = sz.width
            } else {
                w = 0
            }
            w = max(0, w)

            var x: CGFloat = bounds.origin.x + padding.left + chView.marginLeft
            if param.width != MatchParent {
                switch chView.linearParams!.gravityX {
                case .none, .left, .fill:
                    break
                case .right:
                    x = bounds.maxX - padding.right - chView.marginRight - w
                case .center:
                    x = bounds.origin.x + padding.left + (totalWidth - w) / 2
                    break
                }
            }

            let r = Rect(x: x, y: y, width: w, height: h)
            chView.frame = r
            fromY += chView.marginTop + h + chView.marginBottom
        }
        fromY += padding.bottom
        return fromY

    }
}