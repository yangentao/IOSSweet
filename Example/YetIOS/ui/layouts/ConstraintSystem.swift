//
// Created by yangentao on 2021/2/4.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

//superview不能为空的情况
//系统约束布局, 添加布局时, superview不能为空(只有width/height属性且是常量除外)

//func testConstraint() {
//    let a = UIView(frame: .zero)
//    let v = UIView(frame: .zero)
//    //superView.addSubview(v)
//    v.constraintSystem { b in
//        b.left.eqParent()
//        b.top.eqParent()
//        b.centerX.eqParent()
//        b.width.eqSelf(.height)
//        b.height.eqConst(100)
//        b.centerX.eq(view2: a)//.priority(200).ident("helloIdent")
//    }
//    v.constraintChain.centerParent().widthParent(multi: 0.8).heightRatio(multi: 0.5).ident("heightId").install()
//}

public typealias LayoutRelation = NSLayoutConstraint.Relation
public typealias LayoutAxis = NSLayoutConstraint.Axis
public typealias LayoutAttribute = NSLayoutConstraint.Attribute

//public typealias CC = ConstraintItem

public extension UIView {
    @discardableResult
    func sysConstraints(@AnyBuilder _ block: (SysConstraintItemBuilder) -> AnyGroup) -> Self {
        let b = SysConstraintItemBuilder(self)
        let ls: [SysConstraintItem] = block(b).itemsTyped(true)
        for item in ls {
            item.install()
        }
        return self
    }


    var sysConstraintChain: SysConstraintChainBuilder {
        SysConstraintChainBuilder(self)
    }
}

public extension UIView {
    var sysConstraintParams: SysConstraintParams {
        if let ls = getAttr("_conkey_") as? SysConstraintParams {
            return ls
        }
        let c = SysConstraintParams()
        setAttr("_conkey_", c)
        return c
    }

    @discardableResult
    func constraintUpdate(ident: String, constant: CGFloat) -> Self {
        if let a = sysConstraintParams.items.first({ $0.identifier == ident }) {
            a.constant = constant
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
        }
        return self
    }

    func constraintRemoveAll() {
        for c in sysConstraintParams.items {
            c.isActive = false
        }
        sysConstraintParams.items = []
    }

    func constraintRemove(ident: String) {
        let c = sysConstraintParams.items.removeFirstIf { n in
            n.identifier == ident
        }
        c?.isActive = false
    }

    //resist larger than intrinsic content size
    func stretchContent(_ axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue - 1), for: axis)
    }

    //resist smaller than intrinsic content size
    func keepContent(_ axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue + 1), for: axis)
    }
}


public class SysConstraintParams {
    var items = [NSLayoutConstraint]()
}

public class SysConstraintItem {
    fileprivate unowned var view: UIView // view
    fileprivate var attr: LayoutAttribute
    fileprivate var relation: LayoutRelation = .equal
    fileprivate unowned var view2: UIView? = nil
    fileprivate var attr2: LayoutAttribute = .notAnAttribute
    fileprivate var multiplier: CGFloat = 1
    fileprivate var constant: CGFloat = 0
    fileprivate var ident: String? = nil
    fileprivate var priority: UILayoutPriority = .required

    fileprivate init(view: UIView, attr: LayoutAttribute) {
        self.view = view
        self.attr = attr
    }

    public func install() {
        view.translatesAutoresizingMaskIntoConstraints(false)
        let cp = NSLayoutConstraint(item: view as Any, attribute: attr, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: constant)
        cp.priority = priority
        cp.identifier = ident
        view.sysConstraintParams.items.append(cp)
        cp.isActive = true
    }

    public func ident(_ id: String) -> Self {
        ident = id
        return self
    }

    public func priority(_ p: UILayoutPriority) -> Self {
        priority = p
        return self
    }

    public func priority(_ p: Float) -> Self {
        priority = UILayoutPriority(rawValue: p)
        return self
    }

    @discardableResult
    fileprivate func relationTo(rel: LayoutRelation, view2: UIView? = nil, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relation = rel
        self.view2 = view2
        if view2 != nil {
            if let p2 = attr2 {
                self.attr2 = p2
            } else {
                self.attr2 = self.attr
            }
            if self.view === self.view2 && self.attr == self.attr2 {
                fatalError("依赖于自己的同一属性: \(self.attr), \(self.view) ")
            }
        }
        self.multiplier = multi
        self.constant = constant
        return self
    }
}

public class SysConstraintChainBuilder {
    fileprivate unowned let view: UIView
    fileprivate var items: [SysConstraintItem] = []

    fileprivate init(_ view: UIView) {
        self.view = view
    }

    @discardableResult
    public func install() -> UIView {
        items.each {
            $0.install()
        }
        return view
    }

    public func ident(_ id: String) -> Self {
        items.last!.ident = id
        return self
    }

    public func priority(_ p: UILayoutPriority) -> Self {
        items.last!.priority = p
        return self
    }

    public func priority(_ p: Float) -> Self {
        items.last!.priority = UILayoutPriority(rawValue: p)
        return self
    }
}

public extension SysConstraintChainBuilder {

    func edgeXParent(leftConst: CGFloat = 0, rightConst: CGFloat = 0) -> Self {
        leftParent(leftConst).rightParent(rightConst)
    }

    func edgeYParent(topConst: CGFloat = 0, bottomConst: CGFloat = 0) -> Self {
        topParent(topConst).bottomParent(bottomConst)
    }

    func edgesParent(leftConst: CGFloat = 0, rightConst: CGFloat = 0, topConst: CGFloat = 0, bottomConst: CGFloat = 0) -> Self {
        leftParent(leftConst).rightParent(rightConst).topParent(topConst).bottomParent(bottomConst)
    }

    func left(_ c: CGFloat) -> Self {
        items += SysConstraintItem(view: view, attr: .left).relationTo(rel: .equal, constant: c)
        return self
    }

    func right(_ c: CGFloat) -> Self {
        items += SysConstraintItem(view: view, attr: .right).relationTo(rel: .equal, constant: c)
        return self
    }

    func top(_ c: CGFloat) -> Self {
        items += SysConstraintItem(view: view, attr: .top).relationTo(rel: .equal, constant: c)
        return self
    }

    func bottom(_ c: CGFloat) -> Self {
        items += SysConstraintItem(view: view, attr: .bottom).relationTo(rel: .equal, constant: c)
        return self
    }

    func leftParent(_ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .left).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func rightParent(_ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .right).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func topParent(_ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .top).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func bottomParent(_ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .bottom).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func leftEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .left).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func rightEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .right).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func topEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .top).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func bottomEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .bottom).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }


    func centerX(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .centerX).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func centerY(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .centerY).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func center(_ view2: UIView, xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerX(view2, xConst).centerY(view2, yConst)
    }

    func centerXParent(_ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .centerX).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func centerYParent(_ c: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .centerY).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func centerParent(xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerXParent(xConst).centerYParent(yConst)
    }

    func width(_  constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .width).relationTo(rel: .equal, constant: constant)
        return self
    }

    func height(_  constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .height).relationTo(rel: .equal, constant: constant)
        return self
    }

    func width(_ view2: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .width).relationTo(rel: .equal, view2: view2, multi: multi, constant: constant)
        return self
    }

    func height(_ view2: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .height).relationTo(rel: .equal, view2: view2, multi: multi, constant: constant)
        return self
    }

    func widthParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .width).relationTo(rel: .equal, view2: view.superview!, multi: multi, constant: constant)
        return self
    }

    func heightParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .height).relationTo(rel: .equal, view2: view.superview!, multi: multi, constant: constant)
        return self
    }

    //w = h * multi + constant
    func widthRatio(multi: CGFloat, constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .width).relationTo(rel: .equal, view2: view, attr2: .height, multi: multi, constant: constant)
        return self
    }

    //h = w * multi + constant
    func heightRatio(multi: CGFloat, constant: CGFloat = 0) -> Self {
        items += SysConstraintItem(view: view, attr: .height).relationTo(rel: .equal, view2: view, attr2: .width, multi: multi, constant: constant)
        return self
    }
}


public class SysConstraintItemBuilder {
    fileprivate unowned var view: UIView

    fileprivate init(_ view: UIView) {
        self.view = view
    }
}


public extension SysConstraintItemBuilder {
    private func prop(_ attr: LayoutAttribute) -> SysConstraintItemBuilderOne {
        return SysConstraintItemBuilderOne(SysConstraintItem(view: self.view, attr: attr))
    }

    private func props(_ attrs: LayoutAttribute...) -> SysConstraintItemBuilderSome {
        let ls = attrs.map {
            SysConstraintItem(view: self.view, attr: $0)
        }
        return SysConstraintItemBuilderSome(ls)
    }

    var edges: SysConstraintItemBuilderSome {
        props(.left, .top, .right, .bottom)
    }
    var edgeX: SysConstraintItemBuilderSome {
        props(.left, .right)
    }
    var edgeY: SysConstraintItemBuilderSome {
        props(.top, .bottom)
    }

    var leftTop: SysConstraintItemBuilderSome {
        props(.left, .top)
    }
    var leftBottom: SysConstraintItemBuilderSome {
        props(.left, .bottom)
    }
    var rightTop: SysConstraintItemBuilderSome {
        props(.right, .top)
    }
    var rightBottom: SysConstraintItemBuilderSome {
        props(.right, .bottom)
    }
    var size: SysConstraintItemBuilderSome {
        props(.width, .height)
    }
    var center: SysConstraintItemBuilderSome {
        props(.centerX, .centerY)
    }

    //------
    var left: SysConstraintItemBuilderOne {
        prop(.left)
    }
    var right: SysConstraintItemBuilderOne {
        prop(.right)
    }
    var top: SysConstraintItemBuilderOne {
        prop(.top)
    }
    var bottom: SysConstraintItemBuilderOne {
        prop(.bottom)
    }
    var centerX: SysConstraintItemBuilderOne {
        prop(.centerX)
    }
    var centerY: SysConstraintItemBuilderOne {
        prop(.centerY)
    }
    var width: SysConstraintItemBuilderOne {
        prop(.width)
    }
    var height: SysConstraintItemBuilderOne {
        prop(.height)
    }
    var leading: SysConstraintItemBuilderOne {
        prop(.leading)
    }
    var trailing: SysConstraintItemBuilderOne {
        prop(.trailing)
    }

    var lastBaseline: SysConstraintItemBuilderOne {
        prop(.lastBaseline)
    }
    var firstBaseline: SysConstraintItemBuilderOne {
        prop(.firstBaseline)
    }
    var leftMargin: SysConstraintItemBuilderOne {
        prop(.leftMargin)
    }
    var rightMargin: SysConstraintItemBuilderOne {
        prop(.rightMargin)
    }
    var topMargin: SysConstraintItemBuilderOne {
        prop(.topMargin)
    }
    var bottomMargin: SysConstraintItemBuilderOne {
        prop(.bottomMargin)
    }
    var leadingMargin: SysConstraintItemBuilderOne {
        prop(.leadingMargin)
    }
    var trailingMargin: SysConstraintItemBuilderOne {
        prop(.trailingMargin)
    }
    var centerXWithinMargins: SysConstraintItemBuilderOne {
        prop(.centerXWithinMargins)
    }
    var centerYWithinMargins: SysConstraintItemBuilderOne {
        prop(.centerYWithinMargins)
    }
}

public class SysConstraintItemBuilderSome {
    fileprivate var items: [SysConstraintItem] = []

    fileprivate init(_ items: [SysConstraintItem]) {
        self.items = items
    }

}

public extension SysConstraintItemBuilderSome {

    func relationTo(rel: LayoutRelation, view2: UIView?, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        for a in self.items {
            a.relationTo(rel: rel, view2: view2, attr2: attr2, multi: multi, constant: constant)
        }
        return items
    }

    func relationParent(rel: LayoutRelation, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        for a in self.items {
            a.relationTo(rel: rel, view2: a.view.superview!, attr2: attr2, multi: multi, constant: constant)
        }
        return items
    }

    func relationSelf(rel: LayoutRelation, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        for a in self.items {
            a.relationTo(rel: rel, view2: a.view, attr2: attr2, multi: multi, constant: constant)
        }
        return items
    }

    func eq(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        relationTo(rel: .equal, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func ge(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        relationTo(rel: .greaterThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func le(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        relationTo(rel: .lessThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }


    func eqParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        relationParent(rel: .equal, attr2: attr2, multi: multi, constant: constant)
    }

    func geParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        relationParent(rel: .greaterThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func leParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        relationParent(rel: .lessThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func eqSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        return relationSelf(rel: .equal, attr2: attr2, multi: multi, constant: constant)
    }

    func geSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        return relationSelf(rel: .greaterThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func leSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> [SysConstraintItem] {
        return relationSelf(rel: .lessThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func eqConst(_ constant: CGFloat) -> [SysConstraintItem] {
        relationTo(rel: .equal, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func geConst(_ constant: CGFloat) -> [SysConstraintItem] {
        relationTo(rel: .greaterThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func leConst(_ constant: CGFloat) -> [SysConstraintItem] {
        relationTo(rel: .lessThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

}


public class SysConstraintItemBuilderOne {
    fileprivate var item: SysConstraintItem

    fileprivate init(_ item: SysConstraintItem) {
        self.item = item
    }

    fileprivate var view: UIView {
        item.view
    }
    fileprivate var superView: UIView {
        item.view.superview!
    }
}

public extension SysConstraintItemBuilderOne {

    func relationTo(rel: LayoutRelation, view2: UIView?, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        item.relationTo(rel: rel, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func eq(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relationTo(rel: .equal, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func ge(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relationTo(rel: .greaterThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func le(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relationTo(rel: .lessThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }


    func eqParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relationTo(rel: .equal, view2: superView, attr2: attr2, multi: multi, constant: constant)
    }

    func geParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relationTo(rel: .greaterThanOrEqual, view2: superView, attr2: attr2, multi: multi, constant: constant)
    }

    func leParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relationTo(rel: .lessThanOrEqual, view2: superView, attr2: attr2, multi: multi, constant: constant)
    }

    func eqSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        return relationTo(rel: .equal, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func geSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        return relationTo(rel: .greaterThanOrEqual, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func leSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        return relationTo(rel: .lessThanOrEqual, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func eqConst(_ constant: CGFloat) -> SysConstraintItem {
        relationTo(rel: .equal, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func geConst(_ constant: CGFloat) -> SysConstraintItem {
        relationTo(rel: .greaterThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func leConst(_ constant: CGFloat) -> SysConstraintItem {
        relationTo(rel: .lessThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

}
