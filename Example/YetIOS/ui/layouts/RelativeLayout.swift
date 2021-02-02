//
// Created by yangentao on 2021/2/2.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public enum RelativeProp: Int {
    case width, height
    case left, right, top, bottom
    case centerX, centerY

}

public enum RelativeRelation: Int {
    case eq
    case ge, le
}

fileprivate let UNSPEC: CGFloat = -10000

public typealias RC = RelativeCondition

public class RelativeCondition {
    fileprivate let id: Int = nextId()
    fileprivate unowned var view: UIView!
    fileprivate unowned var viewOther: UIView? = nil
    fileprivate var prop: RelativeProp
    fileprivate var relation: RelativeRelation = .eq
    fileprivate var otherViewName: String? = nil
    fileprivate var otherProp: RelativeProp? = nil
    fileprivate var multiplier: CGFloat = 1
    fileprivate var constant: CGFloat = 0

    fileprivate var tempValue: CGFloat = UNSPEC
    fileprivate var OK: Bool {
        tempValue != UNSPEC
    }

    public init(prop: RelativeProp, relation: RelativeRelation = .eq, otherViewName: String? = nil, propOther: RelativeProp? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.prop = prop
        self.relation = relation
        self.otherViewName = otherViewName
        self.otherProp = propOther
        self.multiplier = multiplier
        self.constant = constant
    }

    private static var _lastId: Int = 0

    private static func nextId() -> Int {
        _lastId += 1
        return _lastId
    }


}

public extension RelativeCondition {
    func multi(_ n: CGFloat) -> Self {
        self.multiplier = n
        return self
    }

    func constant(_ n: CGFloat) -> Self {
        self.constant = n
        return self
    }

    func eq(_ otherView: String, _ otherProp: RelativeProp) -> Self {
        self.otherViewName = otherView
        self.otherProp = otherProp
        return self
    }

    func eq(_ otherView: String) -> Self {
        self.otherViewName = otherView
        self.otherProp = self.prop
        return self
    }

    func eq(_ value: CGFloat) -> Self {
        self.constant = value
        return self
    }

    var eqParent: RelativeCondition {
        self.otherViewName = ParentViewName
        self.otherProp = self.prop
        return self
    }

    static var width: RelativeCondition {
        RC(prop: .width)
    }
    static var height: RelativeCondition {
        RC(prop: .height)
    }
    static var left: RelativeCondition {
        RC(prop: .left)
    }
    static var top: RelativeCondition {
        RC(prop: .top)
    }
    static var right: RelativeCondition {
        RC(prop: .right)
    }
    static var bottom: RelativeCondition {
        RC(prop: .bottom)
    }
    static var centerX: RelativeCondition {
        RC(prop: .centerX)
    }
    static var centerY: RelativeCondition {
        RC(prop: .centerY)
    }

    static func width(_ w: CGFloat) -> RelativeCondition {
        width.constant(w)
    }

    static func height(_ h: CGFloat) -> RelativeCondition {
        height.constant(h)
    }
}

public class RelativeParams {
    public var conditions: [RelativeCondition] = []

}

public extension UIView {
    var relativeParams: RelativeParams? {
        get {
            return getAttr("__relativeParam__") as? RelativeParams
        }
        set {
            setAttr("__relativeParam__", newValue)
        }
    }

    var relativeParamsEnsure: RelativeParams {
        if let L = self.relativeParams {
            return L
        } else {
            let a = RelativeParams()
            self.relativeParams = a
            return a
        }
    }

    func relativeConditions(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let ls: [RelativeCondition] = block().itemsTyped(true)
        self.relativeParamsEnsure.conditions.append(contentsOf: ls)
        return self
    }


}

fileprivate class ViewRect {
    var view: UIView
    var left: CGFloat = UNSPEC {
        didSet {
            checkHor()
        }
    }

    var right: CGFloat = UNSPEC {
        didSet {
            checkHor()
        }
    }
    var centerX: CGFloat = UNSPEC {
        didSet {
            checkHor()
        }
    }
    var width: CGFloat = UNSPEC {
        didSet {
            checkHor()
        }
    }


    var bottom: CGFloat = UNSPEC {
        didSet {
            checkVer()
        }
    }
    var top: CGFloat = UNSPEC {
        didSet {
            checkVer()
        }
    }
    var centerY: CGFloat = UNSPEC {
        didSet {
            checkVer()
        }
    }
    var height: CGFloat = UNSPEC {
        didSet {
            checkVer()
        }
    }
    private var checking = false

    init(_ view: UIView) {
        self.view = view
    }

    var OK: Bool {
        if atLeast2(width, left, right, centerX) >= 2 && atLeast2(height, top, bottom, centerY) >= 2 {
            return true
        }
        return false
    }

    var rect: Rect {
        return Rect(x: left, y: top, width: width, height: height)
    }


    private func checkVer() {
        if checking {
            return
        }
        checking = true
        let n = atLeast2(height, top, bottom, centerY)
        if n == 2 || n == 3 {
            doCheckVer()
        }
        checking = false
    }

    private func doCheckVer() {
        if height != UNSPEC && top != UNSPEC {
            bottom = top + height
            centerY = (top + bottom) / 2
            return
        }
        if height != UNSPEC && bottom != UNSPEC {
            top = bottom - height
            centerY = (top + bottom) / 2
            return
        }
        if height != UNSPEC && centerY != UNSPEC {
            top = centerY - height / 2
            bottom = centerY + height / 2
            return
        }

        if top != UNSPEC && bottom != UNSPEC {
            height = bottom - top
            centerY = (top + bottom) / 2
            return
        }
        if top != UNSPEC && centerY != UNSPEC {
            bottom = centerY * 2 - top
            height = bottom - top
            return
        }

        if bottom != UNSPEC && centerY != UNSPEC {
            height = (bottom - centerY) * 2
            top = bottom - height
        }
    }


    private func checkHor() {
        if checking {
            return
        }
        checking = true
        let n = atLeast2(width, left, right, centerX)
        if n == 2 || n == 3 {
            doCheckHor()
        }
        checking = false
    }

    private func doCheckHor() {

        //任意两个决定另外两个
        if width != UNSPEC && left != UNSPEC {
            right = left + width
            centerX = (left + right) / 2
            return
        }
        if width != UNSPEC && right != UNSPEC {
            left = right - width
            centerX = (left + right) / 2
            return
        }
        if width != UNSPEC && centerX != UNSPEC {
            left = centerX - width / 2
            right = centerX + width / 2
            return
        }

        if left != UNSPEC && right != UNSPEC {
            width = right - left
            centerX = (left + right) / 2
            return
        }
        if left != UNSPEC && centerX != UNSPEC {
            right = centerX * 2 - left
            width = right - left
            return
        }

        if right != UNSPEC && centerX != UNSPEC {
            width = (right - centerX) * 2
            left = right - width
        }
    }

    private func atLeast2(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> Int {
        var n = 0
        if a != UNSPEC {
            n += 1
        }
        if b != UNSPEC {
            n += 1
        }
        if c != UNSPEC {
            n += 1
        }
        if d != UNSPEC {
            n += 1
        }
        return n
    }

    func queryProp(_ prop: RelativeProp) -> CGFloat {
        switch prop {
        case .left:
            return left
        case .right:
            return right
        case .top:
            return top
        case .bottom:
            return bottom
        case .centerX:
            return centerX
        case .centerY:
            return centerY
        case .width:
            return width
        case .height:
            return height
        }
    }

    func assignProp(_ prop: RelativeProp, _ value: CGFloat) {
        switch prop {
        case .left:
            left = value
        case .right:
            right = value
        case .top:
            top = value
        case .bottom:
            bottom = value
        case .centerX:
            centerX = value
        case .centerY:
            centerY = value
        case .width:
            width = value
        case .height:
            height = value
        }
    }
}

fileprivate class ViewRects {
    var items: [ViewRect]

    init(_ ls: [UIView]) {
        items = ls.map {
            ViewRect($0)
        }
    }

    private func byView(_ view: UIView) -> ViewRect {
        guard  let vr = items.first({
            $0.view == view
        }) else {
            fatalError("Relative Layout Error: relative view \(view) NOT in subviews")
        }
        return vr
    }

    func queryProp(_ view: UIView, _ prop: RelativeProp) -> CGFloat {
        byView(view).queryProp(prop)
    }

    func assignProp(_ view: UIView, _ prop: RelativeProp, _ value: CGFloat) {
        byView(view).assignProp(prop, value)
    }
}

public extension RelativeLayout {
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

public class RelativeLayout: UIView {


    public override func layoutSubviews() {
        let childList = self.subviews
        if childList.isEmpty {
            return
        }

        var allCond: [RelativeCondition] = []
        for child in childList {
            guard  let param = child.relativeParams else {
                continue
            }
            for cond in param.conditions {
                cond.view = child
                if let otherName = cond.otherViewName {
                    if otherName == ParentViewName {
                        cond.viewOther = self
                    } else if otherName == MineViewName {
                        cond.viewOther = child
                    } else {
                        guard  let vOther = self.findByName(otherName) else {
                            fatalError("View Named '\(otherName)' is NOT found!")
                        }
                        cond.viewOther = vOther
                    }
                }
                cond.tempValue = UNSPEC
                allCond.append(cond)
            }
        }


        let vrList: ViewRects = ViewRects(childList)

        for vr in vrList.items {
            if vr.view.relativeParams == nil {
                vr.left = 0
                vr.right = 0
                vr.width = 0
                vr.height = 0
            }
        }

        for c in allCond {
            if c.viewOther == nil {
                c.tempValue = c.constant
                vrList.assignProp(c.view, c.prop, c.tempValue)
            } else if c.viewOther == self {
                guard let otherProp = c.otherProp else {
                    fatalError("RelativeLayout Error: property \(c.prop) depend superview's property is NOT point out.")
                }
                c.tempValue = queryParentProp(otherProp) * c.multiplier + c.constant
                vrList.assignProp(c.view, c.prop, c.tempValue)
            }

        }

        var matchOne = false
        repeat {
            let notMatchList = allCond.filter {
                !$0.OK
            }
            if notMatchList.isEmpty {
                break
            }
            for c in notMatchList {
                guard  let otherView = c.viewOther else {
                    continue
                }
                guard  let otherProp = c.otherProp else {
                    fatalError("NOT point out relative property name: \(c.view) \(c.relation) \(otherView)")
                }
                let otherVal = vrList.queryProp(otherView, otherProp)
                if otherVal != UNSPEC {
                    c.tempValue = otherVal
                    vrList.assignProp(c.view, c.prop, otherVal)
                    matchOne = true
                }
            }
        } while matchOne

        let notMatchList = allCond.filter {
            !$0.OK
        }
        if !notMatchList.isEmpty {
            print("WARNNING! RelativeLayout: some condition is NOT satisfied ! ")
        }

        for vr in vrList.items {
            if vr.OK {
                vr.view.frame = vr.rect
            }
        }

    }


    private func queryParentProp(_ prop: RelativeProp) -> CGFloat {
        let rect: Rect = self.bounds
        switch prop {
        case .left:
            return rect.minX
        case .right:
            return rect.maxX
        case .top:
            return rect.minY
        case .bottom:
            return rect.maxY
        case .centerX:
            return rect.center.x
        case .centerY:
            return rect.center.y
        case .width:
            return rect.width
        case .height:
            return rect.height
        }
    }
}