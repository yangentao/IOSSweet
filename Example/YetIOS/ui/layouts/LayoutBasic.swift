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
    @discardableResult
    func stretchContent(_ axis: NSLayoutConstraint.Axis) -> Self {
        setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue - 1), for: axis)
        return self
    }


    //resist smaller than intrinsic content size
    @discardableResult
    func keepContent(_ axis: NSLayoutConstraint.Axis) -> Self {
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue + 1), for: axis)
        return self
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

    @discardableResult
    static func +=(lhs: UIView, rhs: UIView) -> UIView {
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

public class Edge: Equatable, Codable {
    public var left: CGFloat
    public var right: CGFloat
    public var top: CGFloat
    public var bottom: CGFloat


    public init(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
}

public extension Edge {
    @discardableResult
    func all(_ v: CGFloat) -> Edge {
        self.left = v
        self.right = v
        self.top = v
        self.bottom = v
        return self
    }

    @discardableResult
    func hor(_ lr: CGFloat) -> Edge {
        self.left = lr
        self.right = lr
        return self
    }

    @discardableResult
    func ver(_ tb: CGFloat) -> Edge {
        self.top = tb
        self.bottom = tb
        return self
    }

    var edgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    static let zero: Edge = Edge()

    static func from(_ edgeInsets: UIEdgeInsets) -> Edge {
        return Edge(left: edgeInsets.left, top: edgeInsets.top, right: edgeInsets.right, bottom: edgeInsets.bottom)
    }

    static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right && lhs.top == rhs.right && lhs.bottom == rhs.bottom
    }

}


internal class CustomLayoutConstraintParams {
    unowned let view: UIView
    var left: NSLayoutConstraint!
    var top: NSLayoutConstraint!
    var width: NSLayoutConstraint!
    var height: NSLayoutConstraint!
    var inited = false

    init(_ view: UIView) {
        self.view = view
    }

    func update(_ rect: Rect) {
        if let parent = view.superview {
            if !inited {
                inited = true
                left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: 0)
                top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: 0)
                width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
                height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
            }
            left.constant = rect.minX
            top.constant = rect.minY
            width.constant = rect.width
            height.constant = rect.height
            left.isActive = true
            top.isActive = true
            width.isActive = true
            height.isActive = true
            view.setNeedsUpdateConstraints()
            parent.setNeedsUpdateConstraints()
        }

    }

}

internal extension UIView {
    var customLayoutConstraintParams: CustomLayoutConstraintParams {
        if let ls = getAttr("_CustomLayoutLinearConstraintParams_") as? CustomLayoutConstraintParams {
            return ls
        }
        let c = CustomLayoutConstraintParams(self)
        setAttr("_CustomLayoutLinearConstraintParams_", c)
        return c
    }
}

public class BaseLayout: UIView {

    public internal (set) var contentSize: CGSize = .zero {
        didSet {
            if oldValue != contentSize {
                processScroll()
                invalidateIntrinsicContentSize()
            }
        }
    }


    public override var intrinsicContentSize: CGSize {
        return contentSize
    }

    public override func addSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizesSubviews = false
        super.addSubview(view)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        processScroll()
    }

    private func processScroll() {
        if let pv = self.superview as? UIScrollView {
            pv.contentSize = contentSize
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.bounds.width == 0 && self.bounds.height == 0 {
            superview?.setNeedsLayout()
            return
        }
        layoutChildren()
    }

    internal func layoutChildren() {

    }

}
