//
// Created by yangentao on 2021/2/4.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

//superview不能为空的情况
//系统约束布局, 添加布局时, superview不能为空(只有width/height属性且是常量除外)




//public typealias CC = ConstraintItem

public extension UIView {
//    @discardableResult
//    func sysConstraints(_ block: (SysConstraintBuilder) -> Void) -> Self {
//        block(SysConstraintBuilder(self))
//        for item in sysConstraintItems.items {
//            item.install()
//        }
//        sysConstraintItems.items = []
//        return self
//    }


    fileprivate var sysConstraintItems: SysConstraintItems {
        if let a = getAttr("__SysConstraintItems__") as? SysConstraintItems {
            return a
        }
        let ls = SysConstraintItems()
        setAttr("__SysConstraintItems__", ls)
        return ls
    }
}

fileprivate class SysConstraintItems {
    var items: [SysConstraintItem] = []
}




public class SysConstraintItem {
    unowned var view: UIView // view
    var attr: LayoutAttribute
    var relation: LayoutRelation = .equal
    fileprivate unowned var otherView: UIView? = nil
    fileprivate var otherAttr: LayoutAttribute = .notAnAttribute
    fileprivate var multiplier: CGFloat = 1
    fileprivate var constant: CGFloat = 0
    fileprivate var ident: String? = nil
    var priority: UILayoutPriority = .required

    fileprivate init(view: UIView, attr: LayoutAttribute) {
        self.view = view
        self.attr = attr
    }

    public func install() {
        view.translatesAutoresizingMaskIntoConstraints(false)
        let cp = NSLayoutConstraint(item: view as Any, attribute: attr, relatedBy: relation, toItem: otherView, attribute: otherAttr, multiplier: multiplier, constant: constant)
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
    fileprivate func relationTo(rel: LayoutRelation, otherView: UIView? = nil, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> SysConstraintItem {
        relation = rel
        self.otherView = otherView
        if otherView != nil {
            if let p = otherAttr {
                self.otherAttr = p
            } else {
                self.otherAttr = self.attr
            }
            if self.view === self.otherView && self.attr == self.otherAttr {
                fatalError("依赖于自己的同一属性: \(self.attr), \(self.view) ")
            }
        }
        self.multiplier = multi
        self.constant = constant
        return self
    }
}

public class SysConstraintBuilder {
    fileprivate unowned var view: UIView

    fileprivate init(_ view: UIView) {
        self.view = view
    }
}

public extension SysConstraintBuilder {

    @discardableResult
    func ident(_ id: String) -> Self {
        view.sysConstraintItems.items.last!.ident = id
        return self
    }

    @discardableResult
    func priority(_ p: UILayoutPriority) -> Self {
        view.sysConstraintItems.items.last!.priority = p
        return self
    }

    @discardableResult
    func priority(_ p: Float) -> Self {
        priority(UILayoutPriority(rawValue: p))
    }

    fileprivate func append(_ attr: LayoutAttribute) -> SysConstraintItem {
        let a = SysConstraintItem(view: view, attr: attr)
        view.sysConstraintItems.items.append(a)
        return a
    }
}

public extension SysConstraintBuilder {
    @discardableResult
    func edgeXParent(leftConst: CGFloat = 0, rightConst: CGFloat = 0) -> Self {
        leftParent(leftConst).rightParent(rightConst)
    }

    @discardableResult
    func edgeYParent(topConst: CGFloat = 0, bottomConst: CGFloat = 0) -> Self {
        topParent(topConst).bottomParent(bottomConst)
    }

    @discardableResult
    func edgesParent(leftConst: CGFloat = 0, rightConst: CGFloat = 0, topConst: CGFloat = 0, bottomConst: CGFloat = 0) -> Self {
        leftParent(leftConst).rightParent(rightConst).topParent(topConst).bottomParent(bottomConst)
    }

    @discardableResult
    func leftParent(_ c: CGFloat = 0) -> Self {
        append(.left).relationTo(rel: .equal, otherView: view.superview!, constant: c)
        return self
    }

    @discardableResult
    func rightParent(_ c: CGFloat = 0) -> Self {
        append(.right).relationTo(rel: .equal, otherView: view.superview!, constant: c)
        return self
    }

    @discardableResult
    func topParent(_ c: CGFloat = 0) -> Self {
        append(.top).relationTo(rel: .equal, otherView: view.superview!, constant: c)
        return self
    }

    @discardableResult
    func bottomParent(_ c: CGFloat = 0) -> Self {
        append(.bottom).relationTo(rel: .equal, otherView: view.superview!, constant: c)
        return self
    }

    @discardableResult
    func centerXParent(_ c: CGFloat = 0) -> Self {
        append(.centerX).relationTo(rel: .equal, otherView: view.superview!, constant: c)
        return self
    }

    @discardableResult
    func centerYParent(_ c: CGFloat = 0) -> Self {
        append(.centerY).relationTo(rel: .equal, otherView: view.superview!, constant: c)
        return self
    }

    @discardableResult
    func centerParent(xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerXParent(xConst).centerYParent(yConst)
    }

    @discardableResult
    func widthParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.width).relationTo(rel: .equal, otherView: view.superview!, multi: multi, constant: constant)
        return self
    }

    @discardableResult
    func heightParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.height).relationTo(rel: .equal, otherView: view.superview!, multi: multi, constant: constant)
        return self
    }

}

public extension SysConstraintBuilder {
    @discardableResult
    func left(_ otherView: UIView, _ c: CGFloat = 0) -> Self {
        append(.left).relationTo(rel: .equal, otherView: otherView, constant: c)
        return self
    }

    @discardableResult
    func right(_ otherView: UIView, _ c: CGFloat = 0) -> Self {
        append(.right).relationTo(rel: .equal, otherView: otherView, constant: c)
        return self
    }

    @discardableResult
    func top(_ otherView: UIView, _ c: CGFloat = 0) -> Self {
        append(.top).relationTo(rel: .equal, otherView: otherView, constant: c)
        return self
    }

    @discardableResult
    func bottom(_ otherView: UIView, _ c: CGFloat = 0) -> Self {
        append(.bottom).relationTo(rel: .equal, otherView: otherView, constant: c)
        return self
    }

    @discardableResult
    func centerX(_ otherView: UIView, _ c: CGFloat = 0) -> Self {
        append(.centerX).relationTo(rel: .equal, otherView: otherView, constant: c)
        return self
    }

    @discardableResult
    func centerY(_ otherView: UIView, _ c: CGFloat = 0) -> Self {
        append(.centerY).relationTo(rel: .equal, otherView: otherView, constant: c)
        return self
    }

    @discardableResult
    func center(_ otherView: UIView, xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerX(otherView, xConst).centerY(otherView, yConst)
    }

    @discardableResult
    func width(_ otherView: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.width).relationTo(rel: .equal, otherView: otherView, multi: multi, constant: constant)
        return self
    }

    @discardableResult
    func height(_ otherView: UIView, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.height).relationTo(rel: .equal, otherView: otherView, multi: multi, constant: constant)
        return self
    }
}

public extension SysConstraintBuilder {
    @discardableResult
    func left(_ viewName: String, _ c: CGFloat = 0) -> Self {
        append(.left).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), constant: c)
        return self
    }

    @discardableResult
    func right(_ viewName: String, _ c: CGFloat = 0) -> Self {
        append(.right).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), constant: c)
        return self
    }

    @discardableResult
    func top(_ viewName: String, _ c: CGFloat = 0) -> Self {
        append(.top).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), constant: c)
        return self
    }

    @discardableResult
    func bottom(_ viewName: String, _ c: CGFloat = 0) -> Self {
        append(.bottom).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), constant: c)
        return self
    }

    @discardableResult
    func centerX(_ viewName: String, _ c: CGFloat = 0) -> Self {
        append(.centerX).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), constant: c)
        return self
    }

    @discardableResult
    func centerY(_ viewName: String, _ c: CGFloat = 0) -> Self {
        append(.centerY).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), constant: c)
        return self
    }

    @discardableResult
    func center(_ viewName: String, xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerX(viewName, xConst).centerY(viewName, yConst)
    }

    @discardableResult
    func width(_ viewName: String, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.width).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), multi: multi, constant: constant)
        return self
    }

    @discardableResult
    func height(_ viewName: String, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.height).relationTo(rel: .equal, otherView: view.superview!.findByName(viewName), multi: multi, constant: constant)
        return self
    }
}

public extension SysConstraintBuilder {
    @discardableResult
    func left(_ c: CGFloat) -> Self {
        append(.left).relationTo(rel: .equal, constant: c)
        return self
    }

    @discardableResult
    func right(_ c: CGFloat) -> Self {
        append(.right).relationTo(rel: .equal, constant: c)
        return self
    }

    @discardableResult
    func top(_ c: CGFloat) -> Self {
        append(.top).relationTo(rel: .equal, constant: c)
        return self
    }

    @discardableResult
    func bottom(_ c: CGFloat) -> Self {
        append(.bottom).relationTo(rel: .equal, constant: c)
        return self
    }

    @discardableResult
    func width(_  constant: CGFloat) -> Self {
        append(.width).relationTo(rel: .equal, constant: constant)
        return self
    }

    @discardableResult
    func height(_  constant: CGFloat) -> Self {
        append(.height).relationTo(rel: .equal, constant: constant)
        return self
    }


    //w = h * multi + constant
    @discardableResult
    func widthRatio(multi: CGFloat, constant: CGFloat = 0) -> Self {
        append(.width).relationTo(rel: .equal, otherView: view, otherAttr: .height, multi: multi, constant: constant)
        return self
    }

    //h = w * multi + constant
    @discardableResult
    func heightRatio(multi: CGFloat, constant: CGFloat = 0) -> Self {
        append(.height).relationTo(rel: .equal, otherView: view, otherAttr: .width, multi: multi, constant: constant)
        return self
    }
}


public extension SysConstraintBuilder {

    private func props(_ attrs: LayoutAttribute...) -> SysConstraintBuilderEnd {
        let ls = attrs.map {
            SysConstraintItem(view: self.view, attr: $0)
        }
        return SysConstraintBuilderEnd(ls)
    }

    var edges: SysConstraintBuilderEnd {
        props(.left, .top, .right, .bottom)
    }
    var edgeX: SysConstraintBuilderEnd {
        props(.left, .right)
    }
    var edgeY: SysConstraintBuilderEnd {
        props(.top, .bottom)
    }

    var leftTop: SysConstraintBuilderEnd {
        props(.left, .top)
    }
    var leftBottom: SysConstraintBuilderEnd {
        props(.left, .bottom)
    }
    var rightTop: SysConstraintBuilderEnd {
        props(.right, .top)
    }
    var rightBottom: SysConstraintBuilderEnd {
        props(.right, .bottom)
    }
    var size: SysConstraintBuilderEnd {
        props(.width, .height)
    }
    var center: SysConstraintBuilderEnd {
        props(.centerX, .centerY)
    }

    //------
    var left: SysConstraintBuilderEnd {
        props(.left)
    }
    var right: SysConstraintBuilderEnd {
        props(.right)
    }
    var top: SysConstraintBuilderEnd {
        props(.top)
    }
    var bottom: SysConstraintBuilderEnd {
        props(.bottom)
    }
    var centerX: SysConstraintBuilderEnd {
        props(.centerX)
    }
    var centerY: SysConstraintBuilderEnd {
        props(.centerY)
    }
    var width: SysConstraintBuilderEnd {
        props(.width)
    }
    var height: SysConstraintBuilderEnd {
        props(.height)
    }
    var leading: SysConstraintBuilderEnd {
        props(.leading)
    }
    var trailing: SysConstraintBuilderEnd {
        props(.trailing)
    }

    var lastBaseline: SysConstraintBuilderEnd {
        props(.lastBaseline)
    }
    var firstBaseline: SysConstraintBuilderEnd {
        props(.firstBaseline)
    }
    var leftMargin: SysConstraintBuilderEnd {
        props(.leftMargin)
    }
    var rightMargin: SysConstraintBuilderEnd {
        props(.rightMargin)
    }
    var topMargin: SysConstraintBuilderEnd {
        props(.topMargin)
    }
    var bottomMargin: SysConstraintBuilderEnd {
        props(.bottomMargin)
    }
    var leadingMargin: SysConstraintBuilderEnd {
        props(.leadingMargin)
    }
    var trailingMargin: SysConstraintBuilderEnd {
        props(.trailingMargin)
    }
    var centerXWithinMargins: SysConstraintBuilderEnd {
        props(.centerXWithinMargins)
    }
    var centerYWithinMargins: SysConstraintBuilderEnd {
        props(.centerYWithinMargins)
    }
}

public class SysConstraintBuilderEnd {
    fileprivate var items: [SysConstraintItem] = []

    fileprivate init(_ items: [SysConstraintItem]) {
        self.items = items
        items.first?.view.sysConstraintItems.items.append(contentsOf: items)
    }

    @discardableResult
    public func ident(_ id: String) -> Self {
        items.each {
            $0.ident = id
        }
        return self
    }

    @discardableResult
    public func priority(_ p: UILayoutPriority) -> Self {
        items.each {
            $0.priority = p
        }
        return self
    }

    @discardableResult
    public func priority(_ p: Float) -> Self {
        priority(UILayoutPriority(rawValue: p))
    }


}

public extension SysConstraintBuilderEnd {

    @discardableResult
    func relationTo(rel: LayoutRelation, otherView: UIView?, otherAttr: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        for a in self.items {
            a.relationTo(rel: rel, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
        }
        return self
    }

    @discardableResult
    func relationParent(rel: LayoutRelation, otherAttr: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        for a in self.items {
            a.relationTo(rel: rel, otherView: a.view.superview!, otherAttr: otherAttr, multi: multi, constant: constant)
        }
        return self
    }

    @discardableResult
    func relationSelf(rel: LayoutRelation, otherAttr: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        for a in self.items {
            a.relationTo(rel: rel, otherView: a.view, otherAttr: otherAttr, multi: multi, constant: constant)
        }
        return self
    }

    @discardableResult
    func eq(_ otherView: UIView?, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .equal, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func ge(_ otherView: UIView?, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .greaterThanOrEqual, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func le(_ otherView: UIView?, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .lessThanOrEqual, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func eq(_ viewName: String, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .equal, otherView: items.last!.view.superview!.findByName(viewName)!, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func ge(_ viewName: String, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .greaterThanOrEqual, otherView: items.last!.view.superview!.findByName(viewName)!, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func le(_ viewName: String, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .lessThanOrEqual, otherView: items.last!.view.superview!.findByName(viewName)!, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func eqParent(otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationParent(rel: .equal, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func geParent(otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationParent(rel: .greaterThanOrEqual, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func leParent(otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationParent(rel: .lessThanOrEqual, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func eqSelf(_ otherAttr: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        return relationSelf(rel: .equal, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func geSelf(_ otherAttr: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        return relationSelf(rel: .greaterThanOrEqual, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func leSelf(_ otherAttr: LayoutAttribute, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        return relationSelf(rel: .lessThanOrEqual, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func eqConst(_ constant: CGFloat) -> Self {
        relationTo(rel: .equal, otherView: nil, otherAttr: .notAnAttribute, multi: 1, constant: constant)
    }

    @discardableResult
    func geConst(_ constant: CGFloat) -> Self {
        relationTo(rel: .greaterThanOrEqual, otherView: nil, otherAttr: .notAnAttribute, multi: 1, constant: constant)
    }

    @discardableResult
    func leConst(_ constant: CGFloat) -> Self {
        relationTo(rel: .lessThanOrEqual, otherView: nil, otherAttr: .notAnAttribute, multi: 1, constant: constant)
    }

}

