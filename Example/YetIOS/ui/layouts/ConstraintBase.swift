//
// Created by yangentao on 2021/1/30.
//

import Foundation
import UIKit


private var _constraint_list_key = "_conkey_"

public class NSLayoutConstraintStore {
    var items = [NSLayoutConstraint]()
}

public extension UIView {
    internal var layoutConstraintItems: NSLayoutConstraintStore {
        if let ls = getAttr(_constraint_list_key) as? NSLayoutConstraintStore {
            return ls
        }
        let c = NSLayoutConstraintStore()
        setAttr(_constraint_list_key, c)
        return c
    }

    @discardableResult
    func updateConstraint(ident: String, constant: CGFloat) -> Self {
        if let a = layoutConstraintItems.items.first({ $0.identifier == ident }) {
            a.constant = constant
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
        }
        return self
    }

    func removeAllConstraints() {
        for c in layoutConstraintItems.items {
            c.isActive = false
        }
        layoutConstraintItems.items = []
    }

    func removeConstraint(ident: String) {
        let c = layoutConstraintItems.items.removeFirstIf { n in
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

public class ConstraintItem {
    unowned var itemView: UIView! // view
    var attr: NSLayoutConstraint.Attribute!
    var relation: NSLayoutConstraint.Relation!
    unowned var toItemView: UIView? = nil
    var toItemName: String? = nil
    var attr2: NSLayoutConstraint.Attribute!
    var multiplier: CGFloat = 1
    var constant: CGFloat = 0
    var ident: String? = nil
    var priority: UILayoutPriority = .required

    init() {

    }

    init(_ attr: NSLayoutConstraint.Attribute) {
        self.attr = attr
        self.attr2 = attr
    }

    public func ident(_ id: String) -> ConstraintItem {
        ident = id
        return self
    }

    public func multi(_ m: CGFloat) -> ConstraintItem {
        multiplier = m
        return self
    }

    public func constant(_ c: CGFloat) -> ConstraintItem {
        constant = c
        return self
    }

    public func priority(_ p: UILayoutPriority) -> ConstraintItem {
        priority = p
        return self
    }

    public func priority(_ p: Float) -> ConstraintItem {
        priority = UILayoutPriority(rawValue: p)
        return self
    }
}

public class ConstraintItemRelation {
    let item: ConstraintItem

    init(_ attr: NSLayoutConstraint.Attribute) {
        item = ConstraintItem(attr)
    }
}

public extension ConstraintItemRelation {

    func eq(_ value: CGFloat) -> ConstraintItem {
        item.relation = .equal
        item.constant = value
        return item
    }

    func eq(_ otherVieName: String) -> ConstraintItem {
        item.relation = .equal
        item.toItemName = otherVieName
        return item
    }

    func eq(_ otherVieName: String, _ attr2: NSLayoutConstraint.Attribute) -> ConstraintItem {
        item.relation = .equal
        item.toItemName = otherVieName
        item.attr2 = attr2
        return item
    }


    var eqParent: ConstraintItem {
        eq(ParentViewName)
    }

    func eqParent(_ attr2: NSLayoutConstraint.Attribute) -> ConstraintItem {
        eq(ParentViewName, attr2)
    }

    //--
    func le(_ value: CGFloat) -> ConstraintItem {
        item.relation = .lessThanOrEqual
        item.constant = value
        return item
    }

    func le(_ otherVieName: String) -> ConstraintItem {
        item.relation = .lessThanOrEqual
        item.toItemName = otherVieName
        return item
    }

    func le(_ otherVieName: String, _ attr2: NSLayoutConstraint.Attribute) -> ConstraintItem {
        item.relation = .lessThanOrEqual
        item.toItemName = otherVieName
        item.attr2 = attr2
        return item
    }


    var leParent: ConstraintItem {
        le(ParentViewName)
    }

    func leParent(_ attr2: NSLayoutConstraint.Attribute) -> ConstraintItem {
        le(ParentViewName, attr2)
    }

    //--

    func ge(_ value: CGFloat) -> ConstraintItem {
        item.relation = .greaterThanOrEqual
        item.constant = value
        return item
    }

    func ge(_ otherVieName: String) -> ConstraintItem {
        item.relation = .greaterThanOrEqual
        item.toItemName = otherVieName
        return item
    }

    func ge(_ otherVieName: String, _ attr2: NSLayoutConstraint.Attribute) -> ConstraintItem {
        item.relation = .greaterThanOrEqual
        item.toItemName = otherVieName
        item.attr2 = attr2
        return item
    }


    var geParent: ConstraintItem {
        ge(ParentViewName)
    }

    func geParent(_ attr2: NSLayoutConstraint.Attribute) -> ConstraintItem {
        ge(ParentViewName, attr2)
    }
}

public typealias CI = ConstraintItemRelation

public extension CI {
    static var left: CI {
        return CI(.left)
    }
}

public var ViewLeft: ConstraintItemRelation {
    ConstraintItemRelation(.left)
}

public var ViewRight: ConstraintItemRelation {
    ConstraintItemRelation(.right)
}

public var ViewTop: ConstraintItemRelation {
    ConstraintItemRelation(.top)
}
public var ViewBottom: ConstraintItemRelation {
    ConstraintItemRelation(.bottom)
}
public var ViewLeading: ConstraintItemRelation {
    ConstraintItemRelation(.leading)
}
public var ViewTrailing: ConstraintItemRelation {
    ConstraintItemRelation(.trailing)
}
public var ViewWidth: ConstraintItemRelation {
    ConstraintItemRelation(.width)
}
public var ViewHeight: ConstraintItemRelation {
    ConstraintItemRelation(.height)
}

public var ViewCenterX: ConstraintItemRelation {
    ConstraintItemRelation(.centerX)
}
public var ViewCenterY: ConstraintItemRelation {
    ConstraintItemRelation(.centerY)
}
public var ViewLastBaseline: ConstraintItemRelation {
    ConstraintItemRelation(.lastBaseline)
}
public var ViewFirstBaseline: ConstraintItemRelation {
    ConstraintItemRelation(.firstBaseline)
}

public var ViewLeftMargin: ConstraintItemRelation {
    ConstraintItemRelation(.leftMargin)
}

public var ViewRightMargin: ConstraintItemRelation {
    ConstraintItemRelation(.rightMargin)
}
public var ViewTopMargin: ConstraintItemRelation {
    ConstraintItemRelation(.topMargin)
}

public var ViewBottomMargin: ConstraintItemRelation {
    ConstraintItemRelation(.bottomMargin)
}

public var ViewLeadingMargin: ConstraintItemRelation {
    ConstraintItemRelation(.leadingMargin)
}
public var ViewTrailingMargin: ConstraintItemRelation {
    ConstraintItemRelation(.trailingMargin)
}
public var ViewCenterXWithinMargins: ConstraintItemRelation {
    ConstraintItemRelation(.centerXWithinMargins)
}

public var ViewCenterYWithinMargins: ConstraintItemRelation {
    ConstraintItemRelation(.centerYWithinMargins)
}


