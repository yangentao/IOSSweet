//
// Created by yangentao on 2021/2/2.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public class RelativeParams {

    public var width: CGFloat = 0
    public var height: CGFloat = 0
    public var gravityX: GravityX = .none
    public var gravityY: GravityY = .none

    @LimitGE(0)
    public var minWidth: CGFloat = 0
    @LimitGE(0)
    public var minHeight: CGFloat = 0

    @LimitGE(0)
    public var maxWidth: CGFloat = 0
    @LimitGE(0)
    public var maxHeight: CGFloat = 0
}

public extension RelativeParams {

    @discardableResult
    func minWidth(_ n: CGFloat) -> Self {
        self.minWidth = n
        return self
    }

    @discardableResult
    func maxWidth(_ n: CGFloat) -> Self {
        self.maxWidth = n
        return self
    }

    @discardableResult
    func minHeight(_ n: CGFloat) -> Self {
        self.minHeight = n
        return self
    }

    @discardableResult
    func maxHeight(_ n: CGFloat) -> Self {
        self.maxHeight = n
        return self
    }

    @discardableResult
    func widthFill() -> Self {
        self.width = MatchParent
        return self
    }

    @discardableResult
    func widthWrap() -> Self {
        self.width = WrapContent
        return self
    }

    @discardableResult
    func heightFill() -> Self {
        self.height = MatchParent
        return self
    }

    @discardableResult
    func heightWrap() -> Self {
        self.height = WrapContent
        return self
    }

    @discardableResult
    func width(_ w: CGFloat) -> Self {
        self.width = w
        return self
    }

    @discardableResult
    func height(_ h: CGFloat) -> Self {
        self.height = h
        return self
    }

    @discardableResult
    func gravityX(_ g: GravityX) -> Self {
        self.gravityX = g
        return self
    }

    @discardableResult
    func gravityY(_ g: GravityY) -> Self {
        self.gravityY = g
        return self
    }

}

public class RelativeLayout: UIView {

    public override func layoutSubviews() {


    }
}