//
// Created by yangentao on 2021/2/1.
//

import Foundation
import UIKit


public var VerticalLinear: LinearLayout {
    LinearLayout(frame: .zero).axis(.vertical)
}
public var HorizontalLinear: LinearLayout {
    LinearLayout(frame: .zero).axis(.horizontal)
}

public extension LinearLayout {
    func buildChildren(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let b = block()
        let viewList: [UIView] = b.itemsTyped()
        let ls = viewList.filter {
            $0 !== self
        }
        for childView in ls {
            addSubview(childView)
        }
        return self
    }
}

public class LinearLayout: UIView {
    public var axis: NSLayoutConstraint.Axis = .vertical
    public var padding: Edge = Edge()

    @discardableResult
    public func axis(_ ax: NSLayoutConstraint.Axis) -> Self {
        self.axis = ax
        return self
    }

    public func paddings(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> Self {
        padding = Edge(l: left, t: top, r: right, b: bottom)
        return self
    }

    public override func layoutSubviews() {
        if self.subviews.count == 0 {
            return
        }
        var sz = bounds.size
        sz.width -= padding.left + padding.right
        sz.height -= padding.top + padding.bottom
        if axis == .vertical {
            let ls = calcSizesVertical(sz)
            layoutChildrenVertical(ls)
        } else {
            let ls = calcSizesHor(sz)
            layoutChildrenHor(ls)
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
            guard  let param = chView.linearParam else {
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
            var useMaxWidthList: [Int] = []
            var fixedWeightSum: CGFloat = 0
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                if pm.maxWidth > 0 {
                    if pm.maxWidth < pm.weight * a {
                        fixedWeightSum += pm.weight
                        szList[i].width = pm.maxWidth
                        useMaxWidthList.append(i)
                        avaliableWidth -= pm.maxWidth
                    }
                }
            }
            unspecIndexList.removeAll(useMaxWidthList)
            //剩下的全是没有设置最大值, 或最大值大于平均值的情况
            let aa = max(0, avaliableWidth) / max(1, weightSum - fixedWeightSum)
            for i in unspecIndexList {
                let pm = childViewList[i].linearParamEnsure
                szList[i].width = pm.minWidth + aa * pm.weight
            }
        }
        return szList
    }

    private func layoutChildrenHor(_ sizeList: [CGSize]) {
        let childViewList = subviews

        let boundsSize = bounds.size
        let totalHeight: CGFloat = boundsSize.height - padding.top - padding.bottom
        var fromX = bounds.origin.x + padding.left
        for (index, chView) in childViewList.enumerated() {
            let xx = fromX + chView.marginLeft
            let ww = sizeList[index].width
            var hh: CGFloat = -1
            let param = chView.linearParam!

            if param.height == MatchParent {
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
                switch chView.linearParam!.gravityY {
                case .none, .top:
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
            guard  let param = chView.linearParam else {
                szList[index] = Size(width: 0, height: 0)
                continue
            }
            avaliableHeight -= chView.marginTop + chView.marginBottom
            if param.height == MatchParent {
                matchSum += 1
            } else if param.height == WrapContent {
                let sz = chView.sizeThatFits(size)
                szList[index].height = max(0, sz.height)
                avaliableHeight -= szList[index].height
            } else if param.height == 0 {
                if param.weight > 0 {
                    weightSum += param.weight
                } else {
                    szList[index].height = 0
                }

            } else if param.height > 0 {
                szList[index].height = max(0, param.height)
                avaliableHeight -= szList[index].height
            } else {
                fatalError("LinearParam.height < 0 ")
            }
        }
        if matchSum > 0 && weightSum > 0 {
            fatalError("LinearParam error , Can not use MatchParent and weight in same time!")
        }
        if matchSum > 0 {
            let h = max(0, avaliableHeight) / matchSum
            for i in 0..<childCount {
                if szList[i].height == unspec {
                    szList[i].height = h
                }
            }
        }
        if weightSum > 0 {
            let a = max(0, avaliableHeight) / weightSum
            for i in 0..<childCount {
                if szList[i].height == unspec {
                    szList[i].height = a * childViewList[i].linearParam!.weight
                }
            }
        }
        return szList
    }

    private func layoutChildrenVertical(_ sizeList: [CGSize]) {
        let childViewList = subviews

        let boundsSize = bounds.size
        let totalWidth: CGFloat = boundsSize.width - padding.left - padding.right
        var fromY = bounds.origin.y + padding.top
        for (index, chView) in childViewList.enumerated() {
            let y = fromY + chView.marginTop
            let h = sizeList[index].height
            var w: CGFloat = -1
            let param = chView.linearParam!

            if param.width == MatchParent {
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
                switch chView.linearParam!.gravityX {
                case .none, .left:
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


    }
}