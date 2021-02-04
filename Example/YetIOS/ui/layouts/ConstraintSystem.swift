//
// Created by yangentao on 2021/2/4.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

//系统约束布局, 添加布局时, superview不能为空(只有width/height属性且是常量除外)

func testConstraint() {
    let a = UIView(frame: .zero)
    let v = UIView(frame: .zero)
    //superView.addSubview(v)
    v.constraintSystem { b in
        b.left.eqParent()
        b.top.eqParent()
        b.centerX.eqParent()
        b.width.eqSelf(.height)
        b.height.eqConst(100)
        b.centerX.eq(view2: a, attr2: .centerX).priority(200).ident("helloIdent")
    }

}

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
}

public class ConstraintItem {
    fileprivate unowned var view: UIView! // view
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
}


public class ConstraintItemBuilder {
    fileprivate unowned var view: UIView

    fileprivate init(_ view: UIView) {
        self.view = view
    }
}


public extension ConstraintItemBuilder {
    private func prop(_ attr: LayoutAttribute) -> ConstraintItemBuilderNext {
        let a = ConstraintItem(view: self.view, attr: attr)
        return ConstraintItemBuilderNext(self.view, item: a)
    }

    var left: ConstraintItemBuilderNext {
        prop(.left)
    }
    var right: ConstraintItemBuilderNext {
        prop(.right)
    }
    var top: ConstraintItemBuilderNext {
        prop(.top)
    }
    var bottom: ConstraintItemBuilderNext {
        prop(.bottom)
    }
    var centerX: ConstraintItemBuilderNext {
        prop(.centerX)
    }
    var centerY: ConstraintItemBuilderNext {
        prop(.centerY)
    }
    var width: ConstraintItemBuilderNext {
        prop(.width)
    }
    var height: ConstraintItemBuilderNext {
        prop(.height)
    }
    var leading: ConstraintItemBuilderNext {
        prop(.leading)
    }
    var trailing: ConstraintItemBuilderNext {
        prop(.trailing)
    }

    var lastBaseline: ConstraintItemBuilderNext {
        prop(.lastBaseline)
    }
    var firstBaseline: ConstraintItemBuilderNext {
        prop(.firstBaseline)
    }
    var leftMargin: ConstraintItemBuilderNext {
        prop(.leftMargin)
    }
    var rightMargin: ConstraintItemBuilderNext {
        prop(.rightMargin)
    }
    var topMargin: ConstraintItemBuilderNext {
        prop(.topMargin)
    }
    var bottomMargin: ConstraintItemBuilderNext {
        prop(.bottomMargin)
    }
    var leadingMargin: ConstraintItemBuilderNext {
        prop(.leadingMargin)
    }
    var trailingMargin: ConstraintItemBuilderNext {
        prop(.trailingMargin)
    }
    var centerXWithinMargins: ConstraintItemBuilderNext {
        prop(.centerXWithinMargins)
    }
    var centerYWithinMargins: ConstraintItemBuilderNext {
        prop(.centerYWithinMargins)
    }
}

public class ConstraintItemBuilderNext {
    fileprivate unowned var view: UIView
    fileprivate let item: ConstraintItem

    fileprivate init(_ view: UIView, item: ConstraintItem) {
        self.view = view
        self.item = item
    }

}

public extension ConstraintItemBuilderNext {

    func relationTo(rel: LayoutRelation, view2: UIView?, attr2: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        let a = self.item
        a.relation = rel
        a.view2 = view2
        if view2 != nil {
            if let p2 = attr2 {
                a.attr2 = p2
            } else {
                a.attr2 = a.attr
            }
        }
        a.multiplier = multi
        a.constant = constant
        return a
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
        relationTo(rel: .equal, view2: view.superview!, attr2: attr2, multi: multi, constant: constant)
    }

    func geParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .greaterThanOrEqual, view2: view.superview!, attr2: attr2, multi: multi, constant: constant)
    }

    func leParent(attr2: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        relationTo(rel: .lessThanOrEqual, view2: view.superview!, attr2: attr2, multi: multi, constant: constant)
    }

    func eqSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        if item.attr == attr2 {
            fatalError("依赖与自己的同一属性: \(attr2)")
        }
        return relationTo(rel: .equal, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func geSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        if item.attr == attr2 {
            fatalError("依赖与自己的同一属性: \(attr2)")
        }
        return relationTo(rel: .greaterThanOrEqual, view2: view, attr2: attr2, multi: multi, constant: constant)
    }

    func leSelf(_ attr2: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> ConstraintItem {
        if item.attr == attr2 {
            fatalError("依赖与自己的同一属性: \(attr2)")
        }
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
