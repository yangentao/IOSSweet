//
// Created by yangentao on 2021/1/30.
//

import Foundation
import UIKit


public extension UIView {


    @discardableResult
    func constraints(_ block: (ConstraintBuilder) -> Void) -> Self {
        block(ConstraintBuilder(self))
        return self
    }


    fileprivate var constraintItems: ConstraintItems {
        if let a = getAttr("__ConstraintItems__") as? ConstraintItems {
            return a
        }
        let ls = ConstraintItems()
        setAttr("__ConstraintItems__", ls)
        return ls
    }


    @discardableResult
    internal func installSelfConstraints() -> Self {
        if superview == nil {
            fatalError("installonstraints() error: superview is nil!")
        }
        constraintItems.items.each {
            $0.install()
        }
        constraintItems.items = []
        return self
    }

}

internal class ConstraintItems {
    var items: [ConstraintItem] = []
}

public class ConstraintItem {
    unowned var view: UIView // view
    var attr: LayoutAttribute
    var relation: LayoutRelation = .equal
    unowned var otherView: UIView? = nil
    var otherName: String? = nil
    var otherAttr: LayoutAttribute = .notAnAttribute
    var multiplier: CGFloat = 1
    var constant: CGFloat = 0
    var ident: String? = nil
    var priority: UILayoutPriority = .required

    init(view: UIView, attr: LayoutAttribute) {
        self.view = view
        self.attr = attr
    }

    public func install() {
        view.translatesAutoresizingMaskIntoConstraints(false)
        let cp = NSLayoutConstraint(item: view as Any, attribute: attr, relatedBy: relation, toItem: makeOtherView(), attribute: otherAttr, multiplier: multiplier, constant: constant)
        cp.priority = priority
        cp.identifier = ident
        view.sysConstraintParams.items.append(cp)
        cp.isActive = true
    }

    private func makeOtherView() -> UIView? {
        if otherView != nil {
            return otherView
        }
        switch otherName {
        case nil:
            return nil
        case SelfViewName:
            return view
        case ParentViewName:
            return view.superview!
        default:
            if otherName == view.superview!.name {
                return view.superview!
            }
            return view.superview!.child(named: otherName!)!
        }
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
    fileprivate func relationTo(rel: LayoutRelation, otherView: UIView, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        self.relation = rel
        self.multiplier = multi
        self.constant = constant
        self.otherView = otherView
        if let p2 = otherAttr {
            self.otherAttr = p2
        } else {
            self.otherAttr = self.attr
        }
        return self
    }

    @discardableResult
    fileprivate func relationTo(rel: LayoutRelation, otherName: String? = nil, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relation = rel
        self.multiplier = multi
        self.constant = constant
        self.otherName = otherName
        if otherName != nil {
            if let p2 = otherAttr {
                self.otherAttr = p2
            } else {
                self.otherAttr = self.attr
            }
        }
        return self
    }

}

public class ConstraintBuilder {
    fileprivate unowned var view: UIView

    fileprivate init(_ view: UIView) {
        self.view = view
    }
}

public extension ConstraintBuilder {

    @discardableResult
    func ident(_ id: String) -> Self {
        view.constraintItems.items.last!.ident = id
        return self
    }

    @discardableResult
    func priority(_ p: UILayoutPriority) -> Self {
        view.constraintItems.items.last!.priority = p
        return self
    }

    @discardableResult
    func priority(_ p: Float) -> Self {
        priority(UILayoutPriority(rawValue: p))
    }

    private func append(_ attr: LayoutAttribute) -> ConstraintItem {
        let item = ConstraintItem(view: view, attr: attr)
        view.constraintItems.items.append(item)
        return item
    }
}

//combine


public extension ConstraintBuilder {

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
    func width(_  constant: CGFloat = 0) -> Self {
        append(.width).relationTo(rel: .equal, constant: constant)
        return self
    }

    @discardableResult
    func height(_  constant: CGFloat = 0) -> Self {
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

//parent
public extension ConstraintBuilder {
    @discardableResult
    func centerParent(xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerXParent(xConst).centerYParent(yConst)
    }

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
        append(.left).relationTo(rel: .equal, otherName: ParentViewName, constant: c)
        return self
    }

    @discardableResult
    func rightParent(_ c: CGFloat = 0) -> Self {
        append(.right).relationTo(rel: .equal, otherName: ParentViewName, constant: c)
        return self
    }

    @discardableResult
    func topParent(_ c: CGFloat = 0) -> Self {
        append(.top).relationTo(rel: .equal, otherName: ParentViewName, constant: c)
        return self
    }

    @discardableResult
    func bottomParent(_ c: CGFloat = 0) -> Self {
        append(.bottom).relationTo(rel: .equal, otherName: ParentViewName, constant: c)
        return self
    }

    @discardableResult
    func widthParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.width).relationTo(rel: .equal, otherName: ParentViewName, multi: multi, constant: constant)
        return self
    }

    @discardableResult
    func heightParent(multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.height).relationTo(rel: .equal, otherName: ParentViewName, multi: multi, constant: constant)
        return self
    }

    @discardableResult
    func centerXParent(_ c: CGFloat = 0) -> Self {
        append(.centerX).relationTo(rel: .equal, otherName: ParentViewName, constant: c)
        return self
    }

    @discardableResult
    func centerYParent(_ c: CGFloat = 0) -> Self {
        append(.centerY).relationTo(rel: .equal, otherName: ParentViewName, constant: c)
        return self
    }
}

public extension ConstraintBuilder {
    @discardableResult
    func left(_ otherName: String, _ c: CGFloat = 0) -> Self {
        append(.left).relationTo(rel: .equal, otherName: otherName, constant: c)
        return self
    }

    @discardableResult
    func right(_  otherName: String, _ c: CGFloat = 0) -> Self {
        append(.right).relationTo(rel: .equal, otherName: otherName, constant: c)
        return self
    }

    @discardableResult
    func top(_  otherName: String, _ c: CGFloat = 0) -> Self {
        append(.top).relationTo(rel: .equal, otherName: otherName, constant: c)
        return self
    }

    @discardableResult
    func bottom(_  otherName: String, _ c: CGFloat = 0) -> Self {
        append(.bottom).relationTo(rel: .equal, otherName: otherName, constant: c)
        return self
    }

    @discardableResult
    func centerX(_  otherName: String, _ c: CGFloat = 0) -> Self {
        append(.centerX).relationTo(rel: .equal, otherName: otherName, constant: c)
        return self
    }

    @discardableResult
    func centerY(_  otherName: String, _ c: CGFloat = 0) -> Self {
        append(.centerY).relationTo(rel: .equal, otherName: otherName, constant: c)
        return self
    }

    @discardableResult
    func center(_  otherName: String, xConst: CGFloat = 0, yConst: CGFloat = 0) -> Self {
        centerX(otherName, xConst).centerY(otherName, yConst)
    }

    @discardableResult
    func width(_ otherName: String, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.width).relationTo(rel: .equal, otherName: otherName, multi: multi, constant: constant)
        return self
    }

    @discardableResult
    func height(_ otherName: String, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        append(.height).relationTo(rel: .equal, otherName: otherName, multi: multi, constant: constant)
        return self
    }
}


//to other
public extension ConstraintBuilder {
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

}


public extension ConstraintBuilder {
    private func props(_ attrs: LayoutAttribute...) -> ConstraintBuilderEnd {
        let ls = attrs.map {
            ConstraintItem(view: self.view, attr: $0)
        }
        return ConstraintBuilderEnd(ls)
    }

    var edges: ConstraintBuilderEnd {
        props(.left, .top, .right, .bottom)
    }
    var edgeX: ConstraintBuilderEnd {
        props(.left, .right)
    }
    var edgeY: ConstraintBuilderEnd {
        props(.top, .bottom)
    }

    var leftTop: ConstraintBuilderEnd {
        props(.left, .top)
    }
    var leftBottom: ConstraintBuilderEnd {
        props(.left, .bottom)
    }
    var rightTop: ConstraintBuilderEnd {
        props(.right, .top)
    }
    var rightBottom: ConstraintBuilderEnd {
        props(.right, .bottom)
    }
    var size: ConstraintBuilderEnd {
        props(.width, .height)
    }
    var center: ConstraintBuilderEnd {
        props(.centerX, .centerY)
    }

    //------
    var left: ConstraintBuilderEnd {
        props(.left)
    }
    var right: ConstraintBuilderEnd {
        props(.right)
    }
    var top: ConstraintBuilderEnd {
        props(.top)
    }
    var bottom: ConstraintBuilderEnd {
        props(.bottom)
    }
    var centerX: ConstraintBuilderEnd {
        props(.centerX)
    }
    var centerY: ConstraintBuilderEnd {
        props(.centerY)
    }
    var width: ConstraintBuilderEnd {
        props(.width)
    }
    var height: ConstraintBuilderEnd {
        props(.height)
    }
    var leading: ConstraintBuilderEnd {
        props(.leading)
    }
    var trailing: ConstraintBuilderEnd {
        props(.trailing)
    }

    var lastBaseline: ConstraintBuilderEnd {
        props(.lastBaseline)
    }
    var firstBaseline: ConstraintBuilderEnd {
        props(.firstBaseline)
    }
    var leftMargin: ConstraintBuilderEnd {
        props(.leftMargin)
    }
    var rightMargin: ConstraintBuilderEnd {
        props(.rightMargin)
    }
    var topMargin: ConstraintBuilderEnd {
        props(.topMargin)
    }
    var bottomMargin: ConstraintBuilderEnd {
        props(.bottomMargin)
    }
    var leadingMargin: ConstraintBuilderEnd {
        props(.leadingMargin)
    }
    var trailingMargin: ConstraintBuilderEnd {
        props(.trailingMargin)
    }
    var centerXWithinMargins: ConstraintBuilderEnd {
        props(.centerXWithinMargins)
    }
    var centerYWithinMargins: ConstraintBuilderEnd {
        props(.centerYWithinMargins)
    }
}

public class ConstraintBuilderEnd {
    fileprivate var items: [ConstraintItem] = []

    fileprivate init(_ items: [ConstraintItem]) {
        self.items = items
        items.first?.view.constraintItems.items.append(contentsOf: items)
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

public extension ConstraintBuilderEnd {

    @discardableResult
    private func relationTo(rel: LayoutRelation, otherView: UIView, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        for a in self.items {
            a.relationTo(rel: rel, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
        }
        return self
    }

    @discardableResult
    private func relationTo(rel: LayoutRelation, otherName: String?, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        for a in self.items {
            a.relationTo(rel: rel, otherName: otherName, otherAttr: otherAttr, multi: multi, constant: constant)
        }
        return self
    }

    @discardableResult
    private func relationParent(rel: LayoutRelation, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        for a in self.items {
            a.relationTo(rel: rel, otherName: ParentViewName, otherAttr: otherAttr, multi: multi, constant: constant)
        }
        return self
    }

    @discardableResult
    private func relationSelf(rel: LayoutRelation, otherAttr: LayoutAttribute?, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        for a in self.items {
            a.relationTo(rel: rel, otherView: a.view, otherAttr: otherAttr, multi: multi, constant: constant)
        }
        return self
    }

    @discardableResult
    func eq(_ otherView: UIView, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .equal, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func ge(_ otherView: UIView, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .greaterThanOrEqual, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func le(_ otherView: UIView, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .lessThanOrEqual, otherView: otherView, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func eq(_ otherName: String, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .equal, otherName: otherName, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func ge(_ otherName: String, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .greaterThanOrEqual, otherName: otherName, otherAttr: otherAttr, multi: multi, constant: constant)
    }

    @discardableResult
    func le(_ otherName: String, otherAttr: LayoutAttribute? = nil, multi: CGFloat = 1, constant: CGFloat = 0) -> Self {
        relationTo(rel: .lessThanOrEqual, otherName: otherName, otherAttr: otherAttr, multi: multi, constant: constant)
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
        relationTo(rel: .equal, otherName: nil, otherAttr: .notAnAttribute, multi: 1, constant: constant)
    }

    @discardableResult
    func geConst(_ constant: CGFloat) -> Self {
        relationTo(rel: .greaterThanOrEqual, otherName: nil, otherAttr: .notAnAttribute, multi: 1, constant: constant)
    }

    @discardableResult
    func leConst(_ constant: CGFloat) -> Self {
        relationTo(rel: .lessThanOrEqual, otherName: nil, otherAttr: .notAnAttribute, multi: 1, constant: constant)
    }

}



