//
// Created by yangentao on 2021/1/30.
//

import Foundation
import UIKit

//
//public func testView() {
//    let view = UIView(frame: .zero)
//    view.layoutConstraint {
//        UILabel(frame: .zero).constraintsBuild {
//            ViewLeft.eq(100)
//            ViewRight.eqParent
//            ViewTop.eq("nameView", .top).multi(2).constant(10)
//        }
//        UILabel(frame: .zero).constraints {
//            $0.centerParent().size(200)
//        }
//    }
//
//}


public extension UIView {

    fileprivate var tempConstraintItemsStore: ConstraintItemStore {
        if let a = getAttr("_constraint_param_list_") as? ConstraintItemStore {
            return a
        }
        let ls = ConstraintItemStore()
        setAttr("_constraint_param_list_", ls)
        return ls
    }

    @discardableResult
    func constraintsBuild(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let ls: [ConstraintCondition] = block().itemsTyped()
        for c in ls {
            c.itemView = self
        }
        tempConstraintItemsStore.items.append(contentsOf: ls)
        return self
    }


    @discardableResult
    func constraints(_ block: (ConstraintsBuilder) -> Void) -> Self {
        let cb = ConstraintsBuilder(self)
        block(cb)
        tempConstraintItemsStore.items.append(contentsOf: cb.items)
        return self
    }

    @discardableResult
    func installMyConstraints() -> Self {
        guard let superView = superview else {
            fatalError("installonstraints() error: superview is nil!")
        }
        let viewList = superView.subviews
        let cList = tempConstraintItemsStore.items
        if cList.isEmpty {
            return self
        }
        tempConstraintItemsStore.items = []
        translatesAutoresizingMaskIntoConstraints = false
        for c in cList {
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

class ConstraintItemStore {
    var items: [ConstraintCondition] = []
}


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
        installChildrenConstaints(ls)
    }

    func installChildrenConstaints(_ viewList: [UIView]? = nil) {
        let ls = viewList ?? subviews
        for v in ls {
            v.installMyConstraints()
        }
    }

}
