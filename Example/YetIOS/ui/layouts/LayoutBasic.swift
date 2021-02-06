//
// Created by entaoyang@163.com on 2017/10/18.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias LayoutRelation = NSLayoutConstraint.Relation
public typealias LayoutAxis = NSLayoutConstraint.Axis
public typealias LayoutAttribute = NSLayoutConstraint.Attribute

public let SelfViewName = "__.__"
public let ParentViewName = "__..__"
public let MatchParent: CGFloat = -1
public let WrapContent: CGFloat = -2


public class SysConstraintParams {
    var items = [NSLayoutConstraint]()

    func removeByID(_ ident: String) {
        let a = items.removeFirstIf {
            $0.identifier == ident
        }
        a?.isActive = false
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

    func constraintRemove(_ ident: String) {
        sysConstraintParams.removeByID(ident)
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

public extension UIView {

    @discardableResult
    func buildViews(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let b = block()
        let viewList: [UIView] = b.itemsTyped().filter {
            $0 !== self
        }
        viewList.each {
            addSubview($0)
        }
        viewList.each {
            $0.installSelfConstraints()
        }
        return self
    }

    @discardableResult
    static func ++=(lhs: UIView, @AnyBuilder _ rhs: AnyBuildBlock) -> UIView {
        lhs.buildViews(rhs)
    }

    @discardableResult
    static func ++=(lhs: UIView, rhs: UIView) -> UIView {
        lhs.addSubview(rhs)
        rhs.installSelfConstraints()
        return lhs
    }
}


public enum GravityX: Int {
    case none = 0
    case left
    case right
    case center
    case fill
}

public enum GravityY: Int {
    case none = 0
    case top
    case bottom
    case center
    case fill
}

public class Edge: Equatable {
    public var left: CGFloat = 0
    public var right: CGFloat = 0
    public var top: CGFloat = 0
    public var bottom: CGFloat = 0

    public init() {

    }

    public convenience init(l: CGFloat, t: CGFloat, r: CGFloat, b: CGFloat) {
        self.init()
        self.left = l
        self.top = t
        self.right = r
        self.bottom = b
    }

    public var edgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    public static let zero: Edge = Edge()

    public static func from(_ edgeInsets: UIEdgeInsets) -> Edge {
        return Edge(l: edgeInsets.left, t: edgeInsets.top, r: edgeInsets.right, b: edgeInsets.bottom)
    }

    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right && lhs.top == rhs.right && lhs.bottom == rhs.bottom
    }

}


public extension UIView {

    var marginLeft: CGFloat {
        get {
            return margins?.left ?? 0
        }
        set {
            marginsEnsure.left = newValue
        }
    }
    var marginTop: CGFloat {
        get {
            return margins?.top ?? 0
        }
        set {
            marginsEnsure.top = newValue
        }
    }
    var marginBottom: CGFloat {
        get {
            return margins?.bottom ?? 0
        }
        set {
            marginsEnsure.bottom = newValue
        }
    }
    var marginRight: CGFloat {
        get {
            return margins?.right ?? 0
        }
        set {
            marginsEnsure.right = newValue
        }
    }
    var marginsEnsure: Edge {
        if let m = margins {
            return m
        }
        let e = Edge()
        margins = e
        return e
    }
    var margins: Edge? {
        get {
            return getAttr("__margins__") as? Edge
        }
        set {
            setAttr("__margins__", newValue)
        }
    }

    func margins(_ l: CGFloat, _ t: CGFloat, _ r: CGFloat, _ b: CGFloat) {
        self.margins = Edge(l: l, t: t, r: r, b: b)
    }

    func margins(_  m: CGFloat) {
        self.margins = Edge(l: m, t: m, r: m, b: m)
    }

    func marginX(_  m: CGFloat) {
        self.marginLeft = m
        self.marginRight = m
    }

    func marginY(_  m: CGFloat) -> Self {
        self.marginTop = m
        self.marginBottom = m
        return self
    }
}



