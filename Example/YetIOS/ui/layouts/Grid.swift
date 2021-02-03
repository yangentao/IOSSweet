//
// Created by yangentao on 2021/2/3.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class GridParam {
    public var width: CGFloat = MatchParent
    public var height: CGFloat = MatchParent
    public var gravityX: GravityX = .center
    public var gravityY: GravityY = .center
    public var spanX: Int = 0
    public var spanY: Int = 0

}

public class Grid: UIView {
    public var axis: LayoutAxis = .vertical

    public var columns: Int = 3

    public var hSpace: CGFloat = 0
    public var vSpace: CGFloat = 0

    public var gravityX: GravityX = .center
    public var gravityY: GravityY = .center


    public override func layoutSubviews() {

    }
}