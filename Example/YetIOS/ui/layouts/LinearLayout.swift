//
// Created by yangentao on 2021/2/1.
//

import Foundation
import UIKit

//TODO weight 优先

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
    func linearParams(_ width: CGFloat, _ height: CGFloat) -> Self {
        linearParamEnsure.width(width).height(height)
        return self
    }

    @discardableResult
    func linearParams(_ width: CGFloat, _ height: CGFloat, _ block: (LinearParams) -> Void) -> Self {
        let a = linearParamEnsure.width(width).height(height)
        block(a)
        return self
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

public class LinearParams: Applyable {

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

    public var margins: Edge = Edge()


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
    public var axis: LayoutAxis = .vertical {
        didSet {
            setNeedsLayout()
        }
    }
    public var padding: Edge = Edge() {
        didSet {
            setNeedsLayout()
        }
    }

    public private(set) var contentSize: CGSize = .zero {
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
        let viewList = self.subviews.filter {
            $0.linearParams != nil
        }
        if viewList.count == 0 {
            return
        }
        let tmpBounds = bounds
        var sz = tmpBounds.size
        sz.width -= padding.left + padding.right
        sz.height -= padding.top + padding.bottom
        var cells: [LinearCell] = viewList.map {
            LinearCell($0)
        }
        if axis == .vertical {
            calcSizesVertical(sz, cells)
            let maxY = layoutChildrenVertical(cells)
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

    private func calcSizesVertical(_ size: CGSize, _ cells: [LinearCell]) {
        var avaliableHeight = size.height
        var weightSum: CGFloat = 0
        var matchSum = 0

        var weightList: [LinearCell] = []
        var matchList: [LinearCell] = []

        for cell in cells {
            avaliableHeight -= cell.param.margins.top + cell.param.margins.bottom
            if cell.param.weight > 0 {
                weightSum += cell.param.weight
                if cell.param.height > cell.param.minHeight {
                    avaliableHeight -= cell.param.height
                } else {
                    avaliableHeight -= cell.param.minHeight
                }
                weightList += cell
                if cell.param.maxHeight > 0 {
                    assert(cell.param.maxHeight >= cell.param.minHeight)
                }
                continue
            }
            if cell.param.height == MatchParent {
                matchSum += 1
                avaliableHeight -= cell.param.minHeight
                matchList += cell
                if cell.param.maxHeight > 0 {
                    assert(cell.param.maxHeight >= cell.param.minHeight)
                }
                continue
            }

            if cell.param.height > 0 {
                cell.height = cell.param.height
                avaliableHeight -= cell.height
                continue
            }
            if cell.param.height == WrapContent {
                let sz = cell.view.sizeThatFits(size)
                cell.height = max(0, sz.height)
                avaliableHeight -= cell.height
                continue
            }


            fatalError("LinearParam.height < 0 ")
        }

        if matchSum > 0 && weightSum > 0 {
            fatalError("LinearParam error , Can not use MatchParent and weight in same time!")
        }
        if matchSum > 0 {
            let ls = matchList.sortedAsc {
                $0.param.maxHeight
            }
            for cell in ls {
                let h = max(0, avaliableHeight) / matchSum
                if cell.param.maxHeight > 0 && cell.param.maxHeight < h {
                    cell.height = cell.param.maxHeight
                    matchSum -= 1
                } else {
                    cell.height = cell.param.minHeight + h
                }
                avaliableHeight -= cell.height
            }
        }
        if weightSum > 0 {
            let ls = weightList.sortedAsc {
                $0.param.maxHeight / $0.param.weight
            }
            for cell in ls {
                let h = max(0, avaliableHeight) / weightSum
                let HH = h * cell.param.weight
                if cell.param.maxHeight > 0 && cell.param.maxHeight < HH {
                    cell.height = cell.param.maxHeight
                    weightSum -= cell.param.weight
                } else {
                    cell.height = cell.param.minHeight + HH
                }
                avaliableHeight -= cell.height
            }
        }
    }

    private func layoutChildrenVertical(_ cells: [LinearCell]) -> CGFloat {
        var fromY = bounds.minY + padding.top

        for cell in cells {
            let param = cell.param
            let WW = bounds.size.width - padding.left - padding.right - param.margins.left - param.margins.right
            var w: CGFloat = 0
            if param.width == MatchParent || param.gravityX == .fill {
                w = WW
            } else if param.width > 0 {
                w = param.width
            } else if param.width == WrapContent {
                let sz = cell.view.sizeThatFits(Size(width: WW, height: cell.height))
                w = sz.width
            } else {
                w = 0
            }
            w = max(0, w)
            cell.width = min(w, WW)


            switch param.gravityX {
            case .none, .left, .fill:
                cell.x = bounds.minX + padding.left + param.margins.left
            case .right:
                cell.x = bounds.maxX - padding.right - param.margins.right - w
            case .center:
                cell.x = bounds.center.x - w / 2
            }
            cell.y = fromY + cell.param.margins.top
            let r = cell.rect
            cell.view.frame = r
            fromY = r.maxY + cell.param.margins.bottom
        }

        fromY += padding.bottom
        return fromY
    }
}

fileprivate let LINEAR_UNSPEC: CGFloat = -1

fileprivate class LinearCell {
    var view: UIView
    lazy var param: LinearParams = view.linearParams!
    var x: CGFloat = LINEAR_UNSPEC
    var y: CGFloat = LINEAR_UNSPEC
    var width: CGFloat = LINEAR_UNSPEC
    var height: CGFloat = LINEAR_UNSPEC

    init(_ view: UIView) {
        self.view = view
    }

    var rect: Rect {
        return Rect(x: x, y: y, width: width, height: height)
    }
}