//
// Created by yangentao on 2021/1/30.
//

import Foundation
import UIKit


//as parent view
public extension UIView {
    func layoutConstraint(@AnyBuilder _ block: AnyBuildBlock) {
        let b = block()
        let viewList: [UIView] = b.itemsTyped()
        let ls = viewList.filter {
            $0 !== self
        }
        for childView in ls {
            addSubview(childView)
        }
        for v in ls {
            v.installMyConstraints()
        }
    }
}

//as subview
public extension UIView {
    @discardableResult
    func constraintConditions(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let ls: [ConstraintCondition] = block().itemsTyped()
        for c in ls {
            c.itemView = self
        }
        constraintConditionItems.items.append(contentsOf: ls)
        return self
    }


    @discardableResult
    func constraintParams(_ block: (ConstraintsBuilder) -> Void) -> Self {
        let cb = ConstraintsBuilder(self)
        block(cb)
        constraintConditionItems.items.append(contentsOf: cb.items)
        return self
    }

    fileprivate var constraintConditionItems: ConstraintConditionItems {
        if let a = getAttr("_constraint_param_list_") as? ConstraintConditionItems {
            return a
        }
        let ls = ConstraintConditionItems()
        setAttr("_constraint_param_list_", ls)
        return ls
    }


    @discardableResult
    internal func installMyConstraints() -> Self {
        guard let superView = superview else {
            fatalError("installonstraints() error: superview is nil!")
        }
        let viewList = superView.subviews
        let condList = constraintConditionItems.items
        if condList.isEmpty {
            return self
        }
        constraintConditionItems.items = []
        translatesAutoresizingMaskIntoConstraints = false
        for c in condList {
            if c.itemView == nil {
                c.itemView = self
            }
            var toItemView: UIView? = nil
            if c.toItemView != nil {
                toItemView = c.toItemView
            } else if let viewName = c.toItemName {
                if viewName == superView.name || viewName == ParentViewName {
                    toItemView = superView
                } else if let toV = viewList.first({ $0.name == viewName }) {
                    toItemView = toV
                } else {
                    fatalError("UIView.constraintLayout, No view name found: \(viewName)")
                }
            }

            let cp = NSLayoutConstraint(item: c.itemView as Any, attribute: c.attr, relatedBy: c.relation, toItem: toItemView, attribute: c.attr2, multiplier: c.multiplier, constant: c.constant)
            cp.priority = c.priority
            cp.identifier = c.ident
            constraintParams.items.append(cp)
            cp.isActive = true
        }
        return self
    }

}

class ConstraintConditionItems {
    var items: [ConstraintCondition] = []
}


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
    func updateConstraint(ident: String, constant: CGFloat) -> Self {
        if let a = constraintParams.items.first({ $0.identifier == ident }) {
            a.constant = constant
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
        }
        return self
    }

    func removeAllConstraints() {
        for c in constraintParams.items {
            c.isActive = false
        }
        constraintParams.items = []
    }

    func removeConstraint(ident: String) {
        let c = constraintParams.items.removeFirstIf { n in
            n.identifier == ident
        }
        c?.isActive = false
    }

    func layoutStretch(_ axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(UILayoutPriority(rawValue: 240), for: axis)
    }

    func layoutKeepContent(_ axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760), for: axis)
    }

}

public typealias ConstraintAttribute = NSLayoutConstraint.Attribute
public typealias CC = ConstraintCondition

public class ConstraintCondition {
    unowned var itemView: UIView! // view
    public var attr: ConstraintAttribute
    public var relation: LayoutRelation = .equal
    unowned var toItemView: UIView? = nil
    public var toItemName: String? = nil
    public var attr2: ConstraintAttribute = .notAnAttribute
    public var multiplier: CGFloat = 1
    public var constant: CGFloat = 0
    public var ident: String? = nil
    public var priority: UILayoutPriority = .required

    public init(_ attr: NSLayoutConstraint.Attribute) {
        self.attr = attr
    }

}

public extension ConstraintCondition {

    func ident(_ id: String) -> Self {
        ident = id
        return self
    }

    func multi(_ m: CGFloat) -> Self {
        multiplier = m
        return self
    }

    func constant(_ c: CGFloat) -> Self {
        constant = c
        return self
    }

    func priority(_ p: UILayoutPriority) -> Self {
        priority = p
        return self
    }

    func priority(_ p: Float) -> Self {
        priority = UILayoutPriority(rawValue: p)
        return self
    }


}

public extension ConstraintCondition {
    func eq(_ otherViewName: String, _ attr2: ConstraintAttribute) -> Self {
        self.relation = .equal
        self.toItemName = otherViewName
        self.attr2 = attr2
        return self
    }


    func eq(_ value: CGFloat) -> Self {
        relation = .equal
        constant = value
        return self
    }

    func eq(_ otherVieName: String) -> Self {
        eq(otherVieName, attr)
    }

    var eqParent: Self {
        eq(ParentViewName)
    }

    func eqParent(_ attr2: ConstraintAttribute) -> Self {
        eq(ParentViewName, attr2)
    }

    func le(_ otherVieName: String, _ attr2: ConstraintAttribute) -> Self {
        relation = .lessThanOrEqual
        self.toItemName = otherVieName
        self.attr2 = attr2
        return self
    }

    func le(_ otherVieName: String) -> Self {
        le(otherVieName, attr)
    }

    func le(_ value: CGFloat) -> Self {
        relation = .lessThanOrEqual
        constant = value
        return self
    }


    var leParent: ConstraintCondition {
        le(ParentViewName)
    }

    func leParent(_ attr2: ConstraintAttribute) -> Self {
        le(ParentViewName, attr2)
    }


    func ge(_ value: CGFloat) -> Self {
        self.relation = .greaterThanOrEqual
        self.constant = value
        return self
    }

    func ge(_ otherVieName: String) -> Self {
        ge(otherVieName, attr)
    }

    func ge(_ otherVieName: String, _ attr2: ConstraintAttribute) -> Self {
        self.relation = .greaterThanOrEqual
        self.toItemName = otherVieName
        self.attr2 = attr2
        return self
    }


    var geParent: Self {
        ge(ParentViewName)
    }

    func geParent(_ attr2: ConstraintAttribute) -> Self {
        ge(ParentViewName, attr2)
    }
}

public extension ConstraintCondition {
    static var left: ConstraintCondition {
        ConstraintCondition(.left)
    }
    static var right: ConstraintCondition {
        ConstraintCondition(.right)
    }
    static var top: ConstraintCondition {
        ConstraintCondition(.top)
    }
    static var bottom: ConstraintCondition {
        ConstraintCondition(.bottom)
    }
    static var centerX: ConstraintCondition {
        ConstraintCondition(.centerX)
    }
    static var centerY: ConstraintCondition {
        ConstraintCondition(.centerY)
    }
    static var width: ConstraintCondition {
        ConstraintCondition(.width)
    }
    static var height: ConstraintCondition {
        ConstraintCondition(.height)
    }
    static var leading: ConstraintCondition {
        ConstraintCondition(.leading)
    }
    static var trailing: ConstraintCondition {
        ConstraintCondition(.trailing)
    }

    static var lastBaseline: ConstraintCondition {
        ConstraintCondition(.lastBaseline)
    }
    static var firstBaseline: ConstraintCondition {
        ConstraintCondition(.firstBaseline)
    }
    static var leftMargin: ConstraintCondition {
        ConstraintCondition(.leftMargin)
    }
    static var rightMargin: ConstraintCondition {
        ConstraintCondition(.rightMargin)
    }
    static var topMargin: ConstraintCondition {
        ConstraintCondition(.topMargin)
    }
    static var bottomMargin: ConstraintCondition {
        ConstraintCondition(.bottomMargin)
    }
    static var leadingMargin: ConstraintCondition {
        ConstraintCondition(.leadingMargin)
    }
    static var trailingMargin: ConstraintCondition {
        ConstraintCondition(.trailingMargin)
    }
    static var centerXWithinMargins: ConstraintCondition {
        ConstraintCondition(.centerXWithinMargins)
    }
    static var centerYWithinMargins: ConstraintCondition {
        ConstraintCondition(.centerYWithinMargins)
    }

}


public class ConstraintsBuilder {
    unowned var view: UIView
    var items: [ConstraintCondition] = []

    init(_ view: UIView) {
        self.view = view
    }
}

public extension ConstraintsBuilder {

    func append(_ item: ConstraintCondition) -> Self {
        item.itemView = view
        items.append(item)
        return self
    }

    //center
    @discardableResult
    func centerXOf(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.centerX.eq(viewName).constant(constant))
    }


    @discardableResult
    func centerYOf(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.centerY.eq(viewName).constant(constant))
    }


    //relative position
    @discardableResult
    func toLeftOf(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.right.eq(viewName, .left).constant(constant))
    }

    @discardableResult
    func toRightOf(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.left.eq(viewName, .right).constant(constant))
    }

    @discardableResult
    func below(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.top.eq(viewName, .bottom).constant(constant))
    }

    @discardableResult
    func above(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.bottom.eq(viewName, .top).constant(constant))
    }


    //edges


    @discardableResult
    func leftEQ(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.left.eq(viewName).constant(constant))
    }


    @discardableResult
    func rightEQ(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.right.eq(viewName).constant(constant))
    }


    @discardableResult
    func topEQ(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.top.eq(viewName).constant(constant))
    }


    @discardableResult
    func bottomEQ(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.bottom.eq(viewName).constant(constant))
    }


    @discardableResult
    func fillXOf(_ viewName: String, _ leftConstant: CGFloat = 0, _ rightConstant: CGFloat = 0) -> Self {
        leftEQ(viewName, leftConstant)
        return rightEQ(viewName, rightConstant)
    }


    @discardableResult
    func fillYOf(_ viewName: String, _ topConstant: CGFloat = 0, _ bottomConstant: CGFloat = 0) -> Self {
        topEQ(viewName, topConstant)
        return bottomEQ(viewName, bottomConstant)
    }


    //height
    @discardableResult
    func heightEQ(_ viewName: String, multi: CGFloat, constant: CGFloat = 0) -> Self {
        append(CC.height.eq(viewName).multi(multi).constant(constant))
    }

    @discardableResult
    func heightEQ(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.height.eq(viewName).constant(constant))
    }


    @discardableResult
    func heightLE(_ width: CGFloat) -> Self {
        append(CC.height.le(width))
    }

    @discardableResult
    func heightGE(_ height: CGFloat) -> Self {
        append(CC.height.ge(height))
    }

    @discardableResult
    func height(_ height: CGFloat) -> Self {
        append(CC.height.eq(height))
    }

    @discardableResult
    func heightEdit() -> Self {
        height(ControlSize.editHeight)
    }

    @discardableResult
    func heightText() -> Self {
        height(ControlSize.textHeight)
    }

    @discardableResult
    func heightButton() -> Self {
        height(ControlSize.buttonHeight)
    }


    //width
    @discardableResult
    func widthEQ(_ viewName: String, multi: CGFloat, constant: CGFloat = 0) -> Self {
        append(CC.width.eq(viewName).multi(multi).constant(constant))
    }

    @discardableResult
    func widthEQ(_ viewName: String, _ constant: CGFloat = 0) -> Self {
        append(CC.width.eq(viewName).constant(constant))
    }


    @discardableResult
    func widthLE(_ width: CGFloat) -> Self {
        append(CC.width.le(width))
    }

    @discardableResult
    func widthGE(_ width: CGFloat) -> Self {
        append(CC.width.ge(width))
    }

    @discardableResult
    func width(_ width: CGFloat) -> Self {
        append(CC.width.eq(width))
    }

    @discardableResult
    func size(_ sz: CGFloat) -> Self {
        width(sz).height(sz)
    }

    @discardableResult
    func size(_ w: CGFloat, _ h: CGFloat) -> Self {
        width(w).height(h)
    }

    @discardableResult
    func widthFit(_ c: CGFloat = 0) -> Self {
        let sz = view.sizeThatFits(CGSize.zero)
        width(sz.width + c)
        return self
    }

    @discardableResult
    func heightFit(_ c: CGFloat = 0) -> Self {
        let sz = view.sizeThatFits(CGSize.zero)
        height(sz.height + c)
        return self
    }

    @discardableResult
    func sizeFit() -> Self {
        let sz = view.sizeThatFits(CGSize.zero)
        width(sz.width)
        height(sz.height)
        return self
    }

    @discardableResult
    func heightByScreen(_ c: CGFloat = 0) -> Self {
        let sz = view.sizeThatFits(Size(width: UIScreen.width, height: 0))
        height(sz.height + c)
        return self
    }
}

public extension ConstraintsBuilder {
    @discardableResult
    func centerX(_ constant: CGFloat = 0) -> Self {
        centerXOf(ParentViewName, constant)
    }

    @discardableResult
    func centerY(_ constant: CGFloat = 0) -> Self {
        centerYOf(ParentViewName, constant)
    }

    @discardableResult
    func center(_ xConstant: CGFloat = 0, _ yConstant: CGFloat = 0) -> Self {
        centerX(xConstant)
        return centerY(yConstant)
    }

    @discardableResult
    func left(_ constant: CGFloat = 0) -> Self {
        leftEQ(ParentViewName, constant)
    }

    @discardableResult
    func right(_ constant: CGFloat = 0) -> Self {
        rightEQ(ParentViewName, constant)
    }

    @discardableResult
    func top(_ constant: CGFloat = 0) -> Self {
        topEQ(ParentViewName, constant)
    }

    @discardableResult
    func bottom(_ constant: CGFloat = 0) -> Self {
        bottomEQ(ParentViewName, constant)
    }

    @discardableResult
    func fillX(_ leftConstant: CGFloat = 0, _ rightConstant: CGFloat = 0) -> Self {
        fillXOf(ParentViewName, leftConstant, rightConstant)
    }

    @discardableResult
    func fillY(_ topConstant: CGFloat = 0, _ bottomConstant: CGFloat = 0) -> Self {
        fillYOf(ParentViewName, topConstant, bottomConstant)
    }

    @discardableResult
    func fill(leftConstant: CGFloat = 0, rightConstant: CGFloat = 0, topConstant: CGFloat = 0, bottomConstant: CGFloat = 0) -> Self {
        fillX(leftConstant, rightConstant)
        return fillY(topConstant, bottomConstant)
    }

    @discardableResult
    func heightParent(_ constant: CGFloat = 0) -> Self {
        heightEQ(ParentViewName, constant)
    }

    @discardableResult
    func widthParent(_ constant: CGFloat = 0) -> Self {
        widthEQ(ParentViewName, constant)
    }

    @discardableResult
    func heightParent(multi: CGFloat, constant: CGFloat = 0) -> Self {
        heightEQ(ParentViewName, multi: multi, constant: constant)
    }

    @discardableResult
    func widthParent(multi: CGFloat, constant: CGFloat = 0) -> Self {
        widthEQ(ParentViewName, multi: multi, constant: constant)
    }
}
