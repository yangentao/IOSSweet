//
// Created by entaoyang on 2019-02-14.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {

    var layout: YetLayout {
        YetLayout(self)
    }

    func layout(block: (YetLayout) -> Void) -> Self {
        block(self.layout)
        return self
    }


}


public class YetLayout {
    private unowned var view: UIView

    public init(_ view: UIView) {
        self.view = view
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
}


public extension YetLayout {

    func removeAll() {
        self.view.constraintRemoveAll()
    }

    func remove(ident: String) {
        self.view.constraintRemove(ident: ident)
    }

    var left: YetLayoutAttr {
        YetLayoutAttr(self.view, .left)
    }

    var right: YetLayoutAttr {
        YetLayoutAttr(self.view, .right)
    }

    var top: YetLayoutAttr {
        YetLayoutAttr(self.view, .top)
    }

    var bottom: YetLayoutAttr {
        YetLayoutAttr(self.view, .bottom)
    }

    var leading: YetLayoutAttr {
        YetLayoutAttr(self.view, .leading)
    }

    var trailing: YetLayoutAttr {
        YetLayoutAttr(self.view, .trailing)
    }

    var width: YetLayoutAttr {
        YetLayoutAttr(self.view, .width)
    }

    var height: YetLayoutAttr {
        YetLayoutAttr(self.view, .height)
    }

    var centerX: YetLayoutAttr {
        YetLayoutAttr(self.view, .centerX)
    }

    var centerY: YetLayoutAttr {
        YetLayoutAttr(self.view, .centerY)
    }

    var lastBaseline: YetLayoutAttr {
        YetLayoutAttr(self.view, .lastBaseline)
    }

    var firstBaseline: YetLayoutAttr {
        YetLayoutAttr(self.view, .firstBaseline)
    }

    var leftMargin: YetLayoutAttr {
        YetLayoutAttr(self.view, .leftMargin)
    }

    var rightMargin: YetLayoutAttr {
        YetLayoutAttr(self.view, .rightMargin)
    }

    var topMargin: YetLayoutAttr {
        YetLayoutAttr(self.view, .topMargin)
    }

    var bottomMargin: YetLayoutAttr {
        YetLayoutAttr(self.view, .bottomMargin)
    }

    var leadingMargin: YetLayoutAttr {
        YetLayoutAttr(self.view, .leadingMargin)
    }

    var trailingMargin: YetLayoutAttr {
        YetLayoutAttr(self.view, .trailingMargin)
    }

    var centerYWithinMargins: YetLayoutAttr {
        YetLayoutAttr(self.view, .centerYWithinMargins)
    }

}

public class YetLayoutAttr {
    let conItem: ConstraintCondition

    init(_ view: UIView, _ attr: NSLayoutConstraint.Attribute) {
        conItem = ConstraintCondition(attr)
        conItem.itemView = view
        conItem.attr2 = .notAnAttribute
    }
}

public class YetLayoutEndNode {
    var conItem: ConstraintCondition

    init(_ item: ConstraintCondition, _ relation: NSLayoutConstraint.Relation, _ constant: CGFloat) {
        self.conItem = item
        self.conItem.relation = relation
        self.conItem.constant = constant
    }

    init(_ item: ConstraintCondition, _ relation: NSLayoutConstraint.Relation, _ view2: UIView) {
        self.conItem = item
        self.conItem.relation = relation
        self.conItem.toItemView = view2
        self.conItem.attr2 = self.conItem.attr
    }

    init(_ item: ConstraintCondition, _ relation: NSLayoutConstraint.Relation, _ view2: UIView, _ attr2: NSLayoutConstraint.Attribute) {
        self.conItem = item
        self.conItem.relation = relation
        self.conItem.toItemView = view2
        self.conItem.attr2 = attr2
    }
}


public extension YetLayoutAttr {

    func eq(_ c: CGFloat) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .equal, c)
    }

    func ge(_ c: CGFloat) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .greaterThanOrEqual, c)
    }

    func le(_ c: CGFloat) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .lessThanOrEqual, c)
    }
}

public extension YetLayoutAttr {

    func eq(_ v: UIView) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .equal, v)
    }

    func ge(_ v: UIView) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .greaterThanOrEqual, v)
    }

    func le(_ v: UIView) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .lessThanOrEqual, v)
    }

    func eq(_ v: UIView, _ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .equal, v, attr2)
    }

    func ge(_ v: UIView, _ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .greaterThanOrEqual, v, attr2)
    }

    func le(_ v: UIView, _ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(conItem, .lessThanOrEqual, v, attr2)
    }
}

public extension YetLayoutAttr {

    func eq(_ viewName: String) -> YetLayoutEndNode {
        if viewName == ParentViewName {
            return YetLayoutEndNode(conItem, .equal, conItem.itemView.superview!)
        } else {
            return YetLayoutEndNode(conItem, .equal, conItem.itemView.superview!.findByName(viewName)!)
        }
    }

    func ge(_ viewName: String) -> YetLayoutEndNode {
        if viewName == ParentViewName {
            return YetLayoutEndNode(conItem, .greaterThanOrEqual, conItem.itemView.superview!)
        } else {
            return YetLayoutEndNode(conItem, .greaterThanOrEqual, conItem.itemView.superview!.findByName(viewName)!)
        }
    }

    func le(_ viewName: String) -> YetLayoutEndNode {
        if viewName == ParentViewName {
            return YetLayoutEndNode(conItem, .lessThanOrEqual, conItem.itemView.superview!)
        } else {
            return YetLayoutEndNode(conItem, .lessThanOrEqual, conItem.itemView.superview!.findByName(viewName)!)
        }
    }

    func eq(_ viewName: String, _ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        if viewName == ParentViewName {
            return YetLayoutEndNode(conItem, .equal, conItem.itemView.superview!, attr2)
        } else {
            return YetLayoutEndNode(conItem, .equal, conItem.itemView.superview!.findByName(viewName)!, attr2)
        }

    }

    func ge(_ viewName: String, _ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        if viewName == ParentViewName {
            return YetLayoutEndNode(conItem, .greaterThanOrEqual, conItem.itemView.superview!, attr2)
        } else {
            return YetLayoutEndNode(conItem, .greaterThanOrEqual, conItem.itemView.superview!.findByName(viewName)!, attr2)
        }
    }

    func le(_ viewName: String, _ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        if viewName == ParentViewName {
            return YetLayoutEndNode(conItem, .lessThanOrEqual, conItem.itemView.superview!, attr2)
        } else {
            return YetLayoutEndNode(conItem, .lessThanOrEqual, conItem.itemView.superview!.findByName(viewName)!, attr2)
        }
    }
}

public extension YetLayoutAttr {

    var eqParent: YetLayoutEndNode {
        eq(conItem.itemView.superview!)
    }
    var geParent: YetLayoutEndNode {
        eq(conItem.itemView.superview!)
    }
    var leParent: YetLayoutEndNode {
        le(conItem.itemView.superview!)
    }


    func eqParent(_ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        eq(conItem.itemView.superview!, attr2)
    }

    func geParent(_ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        ge(conItem.itemView.superview!, attr2)
    }

    func leParent(_ attr2: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        le(conItem.itemView.superview!, attr2)
    }
}

public extension YetLayoutEndNode {

    private func findOld() -> NSLayoutConstraint? {
        let view: UIView = self.conItem.itemView
        let ls = view.sysConstraintParams.items.filter { n in
            n.isActive && n.firstItem === view && n.firstAttribute == self.conItem.attr && n.relation == self.conItem.relation
        }
        if !ls.isEmpty {
            return ls.first
        }
        return nil
    }

    func update() {
        let view: UIView = self.conItem.itemView
        if let c = findOld() {
            c.constant = conItem.constant
            view.setNeedsUpdateConstraints()
            view.superview?.setNeedsUpdateConstraints()
            view.superview?.setNeedsLayout()
        }
    }

    func remove() {
        let view: UIView = self.conItem.itemView
        let c = view.sysConstraintParams.items.removeFirstIf { n in
            n.firstItem === view && n.firstAttribute == conItem.attr && n.relation == conItem.relation
        }
        c?.isActive = false
    }

    @discardableResult
    func active() -> NSLayoutConstraint {
        let n = NSLayoutConstraint(item: conItem.itemView as Any, attribute: conItem.attr, relatedBy: conItem.relation, toItem: conItem.toItemView, attribute: conItem.attr2, multiplier: conItem.multiplier, constant: conItem.constant)
        n.priority = conItem.priority
        n.identifier = conItem.ident
        n.isActive = true
        conItem.itemView.sysConstraintParams.items.append(n)
        return n
    }


    func priority(_ p: UILayoutPriority) -> Self {
        conItem.priority = p
        return self
    }

    func priority(_ n: Int) -> Self {
        conItem.priority = UILayoutPriority(rawValue: Float(n))
        return self
    }

    var priorityLow: Self {
        conItem.priority = UILayoutPriority.defaultLow
        return self
    }
    var priorityHigh: Self {
        conItem.priority = UILayoutPriority.defaultHigh
        return self
    }
    var priorityFittingSize: Self {
        conItem.priority = UILayoutPriority.fittingSizeLevel
        return self
    }

    func ident(_ name: String) -> Self {
        conItem.ident = name
        return self
    }

    func divided(_ m: CGFloat) -> Self {
        conItem.multiplier = 1 / m
        return self
    }

    func multi(_ m: CGFloat) -> Self {
        conItem.multiplier = m
        return self
    }

    func constant(_ c: CGFloat) -> Self {
        conItem.constant = c
        return self
    }
}


public extension YetLayout {
    @discardableResult
    func centerXOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
        self.centerX.eq(v).constant(offset).active()
        return self
    }

    @discardableResult
    func centerYOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
        self.centerY.eq(v).constant(offset).active()
        return self
    }

    @discardableResult
    func toLeftOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
        self.right.eq(v, .left).constant(offset).active()
        return self
    }

    @discardableResult
    func toRightOf(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
        self.left.eq(v, .right).constant(offset).active()
        return self
    }

    @discardableResult
    func below(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
        self.top.eq(v, .bottom).constant(offset).active()
        return self
    }

    @discardableResult
    func above(_ v: UIView, _ offset: CGFloat = 0) -> YetLayout {
        self.bottom.eq(v, .top).constant(offset).active()
        return self
    }

    @discardableResult
    func widthOf(_ v: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> YetLayout {
        self.width.eq(v).multi(multi).constant(constant).active()
        return self
    }

    @discardableResult
    func heightOf(_ v: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> YetLayout {
        self.height.eq(v).multi(multi).constant(constant).active()
        return self
    }

    @discardableResult
    func widthOfParent(multi: CGFloat = 1, constant: CGFloat = 0) -> YetLayout {
        self.width.eq(self.view.superview!).multi(multi).constant(constant).active()
        return self
    }

    @discardableResult
    func heightOfParent(multi: CGFloat = 1, constant: CGFloat = 0) -> YetLayout {
        self.height.eq(self.view.superview!).multi(multi).constant(constant).active()
        return self
    }

    @discardableResult
    func leftOf(_ v: UIView) -> YetLayout {
        self.left.eq(v).active()
        return self
    }

    @discardableResult
    func rightOf(_ v: UIView) -> YetLayout {
        self.right.eq(v).active()
        return self
    }

    @discardableResult
    func topOf(_ v: UIView) -> YetLayout {
        self.top.eq(v).active()
        return self
    }

    @discardableResult
    func bottomOf(_ v: UIView) -> YetLayout {
        self.bottom.eq(v).active()
        return self
    }

    @discardableResult
    func centerParent() -> YetLayout {
        self.centerXParent()
        self.centerYParent()
        return self
    }

    @discardableResult
    func centerXParent(_ offset: CGFloat = 0) -> YetLayout {
        self.centerX.eqParent.constant(offset).active()
        return self
    }

    @discardableResult
    func centerYParent(_ offset: CGFloat = 0) -> YetLayout {
        self.centerY.eqParent.constant(offset).active()
        return self
    }

    @discardableResult
    func fillX() -> YetLayout {
        self.fillX(0, 0)
    }

    @discardableResult
    func fillX(_ leftOffset: CGFloat, _ rightOffset: CGFloat) -> YetLayout {
        self.leftParent(leftOffset)
        return self.rightParent(rightOffset)
    }

    @discardableResult
    func fillY() -> YetLayout {
        self.fillY(0, 0)
    }

    @discardableResult
    func fillY(_ topOffset: CGFloat, _ bottomOffset: CGFloat) -> YetLayout {
        self.topParent(topOffset)
        return self.bottomParent(bottomOffset)
    }

    @discardableResult
    func fill() -> YetLayout {
        fillX()
        fillY(0, 0)
        return self
    }

    @discardableResult
    func topParent(_ n: CGFloat = 0) -> YetLayout {
        self.top.eqParent.constant(n).active()
        return self
    }

    @discardableResult
    func bottomParent(_ n: CGFloat = 0) -> YetLayout {
        self.bottom.eqParent.constant(n).active()
        return self
    }

    @discardableResult
    func leftParent(_ n: CGFloat = 0) -> YetLayout {
        self.left.eqParent.constant(n).active()
        return self
    }

    @discardableResult
    func rightParent(_ n: CGFloat = 0) -> YetLayout {
        self.right.eqParent.constant(n).active()
        return self
    }

    @discardableResult
    func heightLe(_ w: CGFloat) -> YetLayout {
        self.height.le(w).active()
        return self
    }

    @discardableResult
    func heightGe(_ w: CGFloat) -> YetLayout {
        self.height.ge(w).active()
        return self
    }

    @discardableResult
    func height(_ w: CGFloat) -> YetLayout {
        self.height.eq(w).active()
        return self
    }

    @discardableResult
    func heightEdit() -> YetLayout {
        self.height(YetLayoutConst.editHeight)
        return self
    }

    @discardableResult
    func heightText() -> YetLayout {
        self.height(YetLayoutConst.textHeight)
        return self
    }

    @discardableResult
    func heightButton() -> YetLayout {
        self.height(YetLayoutConst.buttonHeight)
        return self
    }

    @discardableResult
    func widthLe(_ w: CGFloat) -> YetLayout {
        self.width.le(w).active()
        return self
    }

    @discardableResult
    func widthGe(_ w: CGFloat) -> YetLayout {
        self.width.ge(w).active()
        return self
    }

    @discardableResult
    func width(_ w: CGFloat) -> YetLayout {
        self.width.eq(w).active()
        return self
    }

    @discardableResult
    func size(_ sz: CGFloat) -> YetLayout {
        self.width(sz).height(sz)
    }

    @discardableResult
    func size(_ w: CGFloat, _ h: CGFloat) -> YetLayout {
        self.width(w).height(h)
    }

    @discardableResult
    func widthFit(_ c: CGFloat = 0) -> YetLayout {
        let sz = self.view.sizeThatFits(CGSize.zero)
        self.width(sz.width + c)
        return self
    }

    @discardableResult
    func heightFit(_ c: CGFloat = 0) -> YetLayout {
        let sz = self.view.sizeThatFits(CGSize.zero)
        self.height(sz.height + c)
        return self
    }

    @discardableResult
    func sizeFit() -> YetLayout {
        let sz = self.view.sizeThatFits(CGSize.zero)
        self.width(sz.width)
        self.height(sz.height)
        return self
    }

    @discardableResult
    func heightByScreen(_ c: CGFloat = 0) -> YetLayout {
        let sz = self.view.sizeThatFits(Size(width: UIScreen.width, height: 0))
        self.height(sz.height + c)
        return self
    }

}

public class YetLayoutConst {
    public static var buttonHeight: CGFloat = 42
    public static var editHeight: CGFloat = 42
    public static var textHeight: CGFloat = 30
}