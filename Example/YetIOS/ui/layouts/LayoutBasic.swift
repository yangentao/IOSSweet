//
// Created by entaoyang@163.com on 2017/10/18.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public let SelfViewName = "__.__"
public let ParentViewName = "__..__"
public let MatchParent: CGFloat = -1
public let WrapContent: CGFloat = -2

public typealias LayoutRelation = NSLayoutConstraint.Relation
public typealias LayoutAxis = NSLayoutConstraint.Axis

public extension UIView {

    @discardableResult
    func buildViews(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let b = block()
        let viewList: [UIView] = b.itemsTyped()
        for childView in viewList {
            if childView !== self {
                addSubview(childView)
            }
        }
        return self
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



