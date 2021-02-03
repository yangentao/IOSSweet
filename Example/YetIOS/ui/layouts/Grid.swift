//
// Created by yangentao on 2021/2/3.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    var gridParams: GridParams? {
        get {
            return getAttr("__gridParam__") as? GridParams
        }
        set {
            setAttr("__gridParam__", newValue)
        }
    }

    var gridParamsEnsure: GridParams {
        if let L = self.gridParams {
            return L
        } else {
            let a = GridParams()
            self.gridParams = a
            return a
        }
    }

    @discardableResult
    func gridParams(_ block: (GridParams) -> Void) -> Self {
        block(gridParamsEnsure)
        return self
    }
}

public class GridParams {
    public var width: CGFloat = 60
    public var height: CGFloat = 60
    public var gravityX: GravityX = .none
    public var gravityY: GravityY = .none
    public var spanX: Int = 0
    public var spanY: Int = 0
}

public extension GridParams {
    func width(_ w: CGFloat) -> Self {
        self.width = w
        return self
    }

    func height(_ h: CGFloat) -> Self {
        self.height = h
        return self
    }
}

public class Grid: UIView {
    public var axis: LayoutAxis = .vertical {
        didSet {
            setNeedsLayout()
        }
    }
    public var gravityX: GravityX = .fill {
        didSet {
            setNeedsLayout()
        }
    }
    public var gravityY: GravityY = .fill {
        didSet {
            setNeedsLayout()
        }
    }
    public var columns: Int = 3 {
        didSet {
            setNeedsLayout()
        }
    }

    public var hSpace: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    public var vSpace: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    private var contentSize: CGSize = .zero {
        didSet {
            if oldValue != contentSize {
                processScroll()
            }
        }
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
        let childViews = self.subviews
        if childViews.isEmpty {
            return
        }
        if axis == .vertical {
            calcSizeVertical(childViews)
        } else {

        }

    }

    private func calcSizeVertical(_ viewList: [UIView]) {

    }
}