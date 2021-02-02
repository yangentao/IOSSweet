//
// Created by entaoyang@163.com on 2017/10/18.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public enum GravityX: Int {
    case none = 0
    case left
    case right
    case center
}

public enum GravityY: Int {
    case none = 0
    case top
    case bottom
    case center
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

public let MatchParent: CGFloat = -1
public let WrapContent: CGFloat = -2

public class LinearParam {
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    public var weight: CGFloat = 0
    public var gravityX: GravityX = .none
    public var gravityY: GravityY = .none

    @discardableResult
    public func widthFill() -> LinearParam {
        self.width = MatchParent
        return self
    }

    @discardableResult
    public func widthWrap() -> LinearParam {
        self.width = WrapContent
        return self
    }

    @discardableResult
    public func heightFill() -> LinearParam {
        self.height = MatchParent
        return self
    }

    @discardableResult
    public func heightWrap() -> LinearParam {
        self.height = WrapContent
        return self
    }

    @discardableResult
    public func width(_ w: CGFloat) -> LinearParam {
        self.width = w
        return self
    }

    @discardableResult
    public func height(_ h: CGFloat) -> LinearParam {
        self.height = h
        return self
    }

    @discardableResult
    public func weight(_ w: CGFloat) -> LinearParam {
        self.weight = w
        return self
    }

    @discardableResult
    public func gravityX(_ g: GravityX) -> LinearParam {
        self.gravityX = g
        return self
    }

    @discardableResult
    public func gravityY(_ g: GravityY) -> LinearParam {
        self.gravityY = g
        return self
    }

}

public extension UIView {
    //minWidth, maxWidth, minHeight, maxHeight
    var linearParam: LinearParam? {
        get {
            return getAttr("__linearParam__") as? LinearParam
        }
        set {
            setAttr("__linearParam__", newValue)
        }
    }

    var linearParamEnsure: LinearParam {
        if let L = self.linearParam {
            return L
        } else {
            let a = LinearParam()
            self.linearParam = a
            return a
        }
    }

    @discardableResult
    func lp(_ width: CGFloat, _ height: CGFloat) -> LinearParam {
        return linearParamEnsure.width(width).height(height)
    }

    @discardableResult
    func linearParam(_ block: (LinearParam) -> Void) -> Self {
        block(linearParamEnsure)
        return self
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

    func marginY(_  m: CGFloat) -> Self  {
        self.marginTop = m
        self.marginBottom = m
        return self
    }
}

