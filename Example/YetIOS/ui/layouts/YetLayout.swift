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

    @discardableResult
    func layout(block: (YetLayout) -> Void) -> Self {
        block(YetLayout(self))
        self.installSelfConstraints()
        return self
    }
}


public class YetLayout {
    private let view: UIView

    public init(_ view: UIView) {
        self.view = view
    }
}


public extension YetLayout {

    func removeAll() {
        self.view.constraintRemoveAll()
    }

    func remove(ident: String) {
        self.view.constraintRemove(ident)
    }

    private func prop(_ attr: LayoutAttribute) -> YetLayoutAttr {
        YetLayoutAttr(ConstraintItem(view: self.view, attr: attr))
    }

    var left: YetLayoutAttr {
        prop(.left)
    }

    var right: YetLayoutAttr {
        prop(.right)
    }

    var top: YetLayoutAttr {
        prop(.top)
    }

    var bottom: YetLayoutAttr {
        prop(.bottom)
    }

    var leading: YetLayoutAttr {
        prop(.leading)
    }

    var trailing: YetLayoutAttr {
        prop(.trailing)
    }

    var width: YetLayoutAttr {
        prop(.width)
    }

    var height: YetLayoutAttr {
        prop(.height)
    }

    var centerX: YetLayoutAttr {
        prop(.centerX)
    }

    var centerY: YetLayoutAttr {
        prop(.centerY)
    }

    var lastBaseline: YetLayoutAttr {
        prop(.lastBaseline)
    }

    var firstBaseline: YetLayoutAttr {
        prop(.firstBaseline)
    }

    var leftMargin: YetLayoutAttr {
        prop(.leftMargin)
    }

    var rightMargin: YetLayoutAttr {
        prop(.rightMargin)
    }

    var topMargin: YetLayoutAttr {
        prop(.topMargin)
    }

    var bottomMargin: YetLayoutAttr {
        prop(.bottomMargin)
    }

    var leadingMargin: YetLayoutAttr {
        prop(.leadingMargin)
    }

    var trailingMargin: YetLayoutAttr {
        prop(.trailingMargin)
    }

    var centerYWithinMargins: YetLayoutAttr {
        prop(.centerYWithinMargins)
    }

}

public class YetLayoutAttr {
    let item: ConstraintItem

    init(_ item: ConstraintItem) {
        self.item = item
        item.view.constraintItems.items.append(item)
    }
}

public class YetLayoutEndNode {
    var item: ConstraintItem

    init(_ item: ConstraintItem, _ relation: NSLayoutConstraint.Relation, _ view2: UIView?, _ attr2: NSLayoutConstraint.Attribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) {
        self.item = item
        self.item.relation = relation
        self.item.otherView = view2
        self.item.multiplier = multi
        self.item.constant = constant
        if view2 != nil {
            if attr2 == nil {
                self.item.otherAttr = self.item.attr
            } else {
                self.item.otherAttr = attr2!
            }
        }
    }

    init(_ item: ConstraintItem, _ relation: NSLayoutConstraint.Relation, _ viewName: String, _ attr2: NSLayoutConstraint.Attribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) {
        self.item = item
        self.item.relation = relation
        self.item.otherName = viewName
        self.item.multiplier = multi
        self.item.constant = constant
        if attr2 == nil {
            self.item.otherAttr = self.item.attr
        } else {
            self.item.otherAttr = attr2!
        }
    }
}


public extension YetLayoutAttr {

    func eq(_ c: CGFloat) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .equal, nil, constant: c)
    }

    func ge(_ c: CGFloat) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .greaterThanOrEqual, nil, constant: c)
    }

    func le(_ c: CGFloat) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .lessThanOrEqual, nil, constant: c)
    }
}

public extension YetLayoutAttr {
    @discardableResult
    func eq(_ v: UIView) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .equal, v)
    }

    @discardableResult
    func ge(_ v: UIView) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .greaterThanOrEqual, v)
    }

    @discardableResult
    func le(_ v: UIView) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .lessThanOrEqual, v)
    }

    @discardableResult
    func eq(_ v: UIView, _ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .equal, v, otherAttr)
    }

    @discardableResult
    func ge(_ v: UIView, _ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .greaterThanOrEqual, v, otherAttr)
    }

    @discardableResult
    func le(_ v: UIView, _ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .lessThanOrEqual, v, otherAttr)
    }
}

public extension YetLayoutAttr {

    @discardableResult
    func eq(_ viewName: String) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .equal, viewName)
    }

    @discardableResult
    func ge(_ viewName: String) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .greaterThanOrEqual, viewName)
    }

    @discardableResult
    func le(_ viewName: String) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .lessThanOrEqual, viewName)
    }

    @discardableResult
    func eq(_ viewName: String, _ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .equal, viewName, otherAttr)

    }

    @discardableResult
    func ge(_ viewName: String, _ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .greaterThanOrEqual, viewName, otherAttr)
    }

    @discardableResult
    func le(_ viewName: String, _ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        YetLayoutEndNode(item, .lessThanOrEqual, viewName, otherAttr)
    }
}

public extension YetLayoutAttr {
    var eqParent: YetLayoutEndNode {
        eq(ParentViewName)
    }
    var geParent: YetLayoutEndNode {
        eq(ParentViewName)
    }
    var leParent: YetLayoutEndNode {
        le(ParentViewName)
    }

    @discardableResult
    func eqParent(_ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        eq(ParentViewName, otherAttr)
    }

    @discardableResult
    func geParent(_ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        ge(ParentViewName, otherAttr)
    }

    @discardableResult
    func leParent(_ otherAttr: NSLayoutConstraint.Attribute) -> YetLayoutEndNode {
        le(ParentViewName, otherAttr)
    }
}

public extension YetLayoutEndNode {

    private func findOldIdent() -> String? {
        let view: UIView = self.item.view
        return view.sysConstraintParams.items.filter { n in
            n.isActive && n.firstItem === view && n.firstAttribute == self.item.attr && n.relation == self.item.relation
        }.first?.identifier
    }

    func update() {
        if let s = findOldIdent() {
            item.view.constraintUpdate(ident: s, constant: item.constant)
        }
        item.view.constraintItems.removeByID(item._ID)
    }

    func remove() {
        if let s = findOldIdent() {
            item.view.constraintRemove(s)
        }
        item.view.constraintItems.removeByID(item._ID)
    }

    func active() {
        item.view.constraintItems.removeByID(item._ID)
        item.install()
    }


    func priority(_ p: UILayoutPriority) -> Self {
        item.priority = p
        return self
    }

    func priority(_ n: Int) -> Self {
        item.priority = UILayoutPriority(rawValue: Float(n))
        return self
    }

    var priorityLow: Self {
        item.priority = UILayoutPriority.defaultLow
        return self
    }
    var priorityHigh: Self {
        item.priority = UILayoutPriority.defaultHigh
        return self
    }
    var priorityFittingSize: Self {
        item.priority = UILayoutPriority.fittingSizeLevel
        return self
    }

    func ident(_ name: String) -> Self {
        item.ident = name
        return self
    }

    func divided(_ m: CGFloat) -> Self {
        item.multiplier = 1 / m
        return self
    }

    func multi(_ m: CGFloat) -> Self {
        item.multiplier = m
        return self
    }

    func constant(_ c: CGFloat) -> Self {
        item.constant = c
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
        self.width.eq(ParentViewName).multi(multi).constant(constant).active()
        return self
    }

    @discardableResult
    func heightOfParent(multi: CGFloat = 1, constant: CGFloat = 0) -> YetLayout {
        self.height.eq(ParentViewName).multi(multi).constant(constant).active()
        return self
    }

    //w = h * multi + constant
    @discardableResult
    func widthRatio(multi: CGFloat, constant: CGFloat = 0) -> Self {
        self.width.eq(self.view, .height).multi(multi).constant(constant).active()
        return self
    }

    //h = w * multi + constant
    @discardableResult
    func heightRatio(multi: CGFloat, constant: CGFloat = 0) -> Self {
        self.height.eq(self.view, .width).multi(multi).constant(constant).active()
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