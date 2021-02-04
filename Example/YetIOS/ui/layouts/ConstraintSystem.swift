//
// Created by yangentao on 2021/2/4.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

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
//}

public typealias LayoutRelation = NSLayoutConstraint.Relation
public typealias LayoutAxis = NSLayoutConstraint.Axis
public typealias LayoutAttribute = NSLayoutConstraint.Attribute

//public typealias CC = ConstraintItem

public class ConstraintParams {
    var items = [NSLayoutConstraint]()
}

public extension UIView {
    var constraintParams: ConstraintParams {
        if let ls = getAttr("_conkey_") as? ConstraintParams {
            return ls
        }
        let c = ConstraintParams()
        setAttr("_conkey_", c)
        return c
    }

    @discardableResult
    func constraintUpdate(ident: String, constant: CGFloat) -> Self {
        if let a = constraintParams.items.first({ $0.identifier == ident }) {
            a.constant = constant
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
        }
        return self
    }

    func constraintRemoveAll() {
        for c in constraintParams.items {
            c.isActive = false
        }
        constraintParams.items = []
    }

    func constraintRemove(ident: String) {
        let c = constraintParams.items.removeFirstIf { n in
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

extension UIView {
    @discardableResult
    func constraintSystem(@AnyBuilder _ block: (ConstraintItemBuilder) -> AnyGroup) -> Self {
        let b = ConstraintItemBuilder(self)
        let ls: [ConstraintItem] = block(b).itemsTyped(true)
        for item in ls {
            item.install()
        }
        return self
    }

    var constraintChain: ConstraintChainBuilder {
        ConstraintChainBuilder(self)
    }
}

public class ConstraintItem {
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
        view.constraintParams.items.append(cp)
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
    fileprivate func relationTo(rel: LayoutRelation, view2: UIView? = nil, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
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

public class ConstraintChainBuilder {
    fileprivate unowned let view: UIView
    fileprivate var items: [ConstraintItem] = []

    fileprivate init(_ view: UIView) {
        self.view = view
    }

    public func install() {
        items.each {
            $0.install()
        }
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

public extension ConstraintChainBuilder {

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
        items += ConstraintItem(view: view, attr: .left).relationTo(rel: .equal, constant: c)
        return self
    }

    func right(_ c: CGFloat) -> Self {
        items += ConstraintItem(view: view, attr: .right).relationTo(rel: .equal, constant: c)
        return self
    }

    func top(_ c: CGFloat) -> Self {
        items += ConstraintItem(view: view, attr: .top).relationTo(rel: .equal, constant: c)
        return self
    }

    func bottom(_ c: CGFloat) -> Self {
        items += ConstraintItem(view: view, attr: .bottom).relationTo(rel: .equal, constant: c)
        return self
    }

    func leftParent(_ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .left).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func rightParent(_ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .right).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func topParent(_ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .top).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func bottomParent(_ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .bottom).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func leftEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .left).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func rightEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .right).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func topEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .top).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func bottomEQ(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .bottom).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }


    func centerX(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .centerX).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func centerY(_ view2: UIView, _ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .centerY).relationTo(rel: .equal, view2: view2, constant: c)
        return self
    }

    func center(_ view2: UIView, xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerX(view2, xConst).centerY(view2, yConst)
    }

    func centerXParent(_ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .centerX).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func centerYParent(_ c: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .centerY).relationTo(rel: .equal, view2: view.superview!, constant: c)
        return self
    }

    func centerParent(xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerXParent(xConst).centerYParent(yConst)
    }

    func width(_  constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .width).relationTo(rel: .equal, constant: constant)
        return self
    }

    func height(_  constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .height).relationTo(rel: .equal, constant: constant)
        return self
    }

    func width(_ view2: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .width).relationTo(rel: .equal, view2: view2, multi: multi, constant: constant)
        return self
    }

    func height(_ view2: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .height).relationTo(rel: .equal, view2: view2, multi: multi, constant: constant)
        return self
    }

    func widthParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .width).relationTo(rel: .equal, view2: view.superview!, multi: multi, constant: constant)
        return self
    }

    func heightParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .height).relationTo(rel: .equal, view2: view.superview!, multi: multi, constant: constant)
        return self
    }

    //w = h * multi + constant
    func widthRatio(multi: CGFloat , constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .width).relationTo(rel: .equal, view2: view, attr2: .height, multi: multi, constant: constant)
        return self
    }

    //h = w * multi + constant
    func heightRatio(multi: CGFloat, constant: CGFloat = 0) -> Self {
        items += ConstraintItem(view: view, attr: .height).relationTo(rel: .equal, view2: view, attr2: .width, multi: multi, constant: constant)
        return self
    }
}


public class ConstraintItemBuilder {
    fileprivate unowned var view: UIView

    fileprivate init(_ view: UIView) {
        self.view = view
    }
}


public extension ConstraintItemBuilder {
    private func prop(_ attr: LayoutAttribute) -> ConstraintItemBuilderOne {
        return ConstraintItemBuilderOne(ConstraintItem(view: self.view, attr: attr))
    }

    private func props(_ attrs: LayoutAttribute...) -> ConstraintItemBuilderSome {
        let ls = attrs.map {
            ConstraintItem(view: self.view, attr: $0)
        }
        return ConstraintItemBuilderSome(ls)
    }

    var edges: ConstraintItemBuilderSome {
        props(.left, .top, .right, .bottom)
    }
    var edgeX: ConstraintItemBuilderSome {
        props(.left, .right)
    }
    var edgeY: ConstraintItemBuilderSome {
        props(.top, .bottom)
    }

    var leftTop: ConstraintItemBuilderSome {
        props(.left, .top)
    }
    var leftBottom: ConstraintItemBuilderSome {
        props(.left, .bottom)
    }
    var rightTop: ConstraintItemBuilderSome {
        props(.right, .top)
    }
    var rightBottom: ConstraintItemBuilderSome {
        props(.right, .bottom)
    }
    var size: ConstraintItemBuilderSome {
        props(.width, .height)
    }
    var center: ConstraintItemBuilderSome {
        props(.centerX, .centerY)
    }

    //------
    var left: ConstraintItemBuilderOne {
        prop(.left)
    }
    var right: ConstraintItemBuilderOne {
        prop(.right)
    }
    var top: ConstraintItemBuilderOne {
        prop(.top)
    }
    var bottom: ConstraintItemBuilderOne {
        prop(.bottom)
    }
    var centerX: ConstraintItemBuilderOne {
        prop(.centerX)
    }
    var centerY: ConstraintItemBuilderOne {
        prop(.centerY)
    }
    var width: ConstraintItemBuilderOne {
        prop(.width)
    }
    var height: ConstraintItemBuilderOne {
        prop(.height)
    }
    var leading: ConstraintItemBuilderOne {
        prop(.leading)
    }
    var trailing: ConstraintItemBuilderOne {
        prop(.trailing)
    }

    var lastBaseline: ConstraintItemBuilderOne {
        prop(.lastBaseline)
    }
    var firstBaseline: ConstraintItemBuilderOne {
        prop(.firstBaseline)
    }
    var leftMargin: ConstraintItemBuilderOne {
        prop(.leftMargin)
    }
    var rightMargin: ConstraintItemBuilderOne {
        prop(.rightMargin)
    }
    var topMargin: ConstraintItemBuilderOne {
        prop(.topMargin)
    }
    var bottomMargin: ConstraintItemBuilderOne {
        prop(.bottomMargin)
    }
    var leadingMargin: ConstraintItemBuilderOne {
        prop(.leadingMargin)
    }
    var trailingMargin: ConstraintItemBuilderOne {
        prop(.trailingMargin)
    }
    var centerXWithinMargins: ConstraintItemBuilderOne {
        prop(.centerXWithinMargins)
    }
    var centerYWithinMargins: ConstraintItemBuilderOne {
        prop(.centerYWithinMargins)
    }
}

public class ConstraintItemBuilderSome {
    fileprivate var items: [ConstraintItem] = []

    fileprivate init(_ items: [ConstraintItem]) {
        self.items = items
    }

}

public extension ConstraintItemBuilderSome {

    func relationTo(rel: LayoutRelation, view2: UIView?, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        for a in self.items {
            a.relationTo(rel: rel, view2: view2, attr2: attr2, multi: multi, constant: constant)
        }
        return items
    }

    func relationParent(rel: LayoutRelation, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        for a in self.items {
            a.relationTo(rel: rel, view2: a.view.superview!, attr2: attr2, multi: multi, constant: constant)
        }
        return items
    }

    func relationSelf(rel: LayoutRelation, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        for a in self.items {
            a.relationTo(rel: rel, view2: a.view, attr2: attr2, multi: multi, constant: constant)
        }
        return items
    }

    func eq(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        relationTo(rel: .equal, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func ge(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        relationTo(rel: .greaterThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func le(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        relationTo(rel: .lessThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }


    func eqParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        relationParent(rel: .equal, attr2: attr2, multi: multi, constant: constant)
    }

    func geParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        relationParent(rel: .greaterThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func leParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        relationParent(rel: .lessThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func eqSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        return relationSelf(rel: .equal, attr2: attr2, multi: multi, constant: constant)
    }

    func geSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        return relationSelf(rel: .greaterThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func leSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> [ConstraintItem] {
        return relationSelf(rel: .lessThanOrEqual, attr2: attr2, multi: multi, constant: constant)
    }

    func eqConst(_ constant: CGFloat) -> [ConstraintItem] {
        relationTo(rel: .equal, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func geConst(_ constant: CGFloat) -> [ConstraintItem] {
        relationTo(rel: .greaterThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func leConst(_ constant: CGFloat) -> [ConstraintItem] {
        relationTo(rel: .lessThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

}


public class ConstraintItemBuilderOne {
    fileprivate var item: ConstraintItem

    fileprivate init(_ item: ConstraintItem) {
        self.item = item
    }

    fileprivate var view: UIView {
        item.view
    }
    fileprivate var superView: UIView {
        item.view.superview!
    }
}

public extension ConstraintItemBuilderOne {

    func relationTo(rel: LayoutRelation, view2: UIView?, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        item.relationTo(rel: rel, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func eq(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .equal, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func ge(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .greaterThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }

    func le(view2: UIView?, attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .lessThanOrEqual, view2: view2, attr2: attr2, multi: multi, constant: constant)
    }


    func eqParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .equal, view2: superView, attr2: attr2, multi: multi, constant: constant)
    }

    func geParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .greaterThanOrEqual, view2: superView, attr2: attr2, multi: multi, constant: constant)
    }

    func leParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .lessThanOrEqual, view2: superView, attr2: attr2, multi: multi, constant: constant)
    }

    func eqSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        return relationTo(rel: .equal, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func geSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        return relationTo(rel: .greaterThanOrEqual, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func leSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        return relationTo(rel: .lessThanOrEqual, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func eqConst(_ constant: CGFloat) -> ConstraintItem {
        relationTo(rel: .equal, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func geConst(_ constant: CGFloat) -> ConstraintItem {
        relationTo(rel: .greaterThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

    func leConst(_ constant: CGFloat) -> ConstraintItem {
        relationTo(rel: .lessThanOrEqual, view2: nil, attr2: .notAnAttribute, multi: 1, constant: constant)
    }

}
