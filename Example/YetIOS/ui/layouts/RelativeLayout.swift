//
// Created by yangentao on 2021/2/2.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public enum RelativeProp: Int {
    case width, height
    case left, right, top, bottom
    case centerX, centerY

}

public enum RelativeRelation: Int {
    case eq, ge, le
}


public class RelativeCondition {
    var me: String = MineViewName
    var prop: RelativeProp
    var relation: RelativeRelation = .eq
    var other: String? = nil
    var propOther: RelativeProp? = nil
    var multiplier: CGFloat = 1
    var constant: CGFloat = 0

    init(_ prop: RelativeProp) {
        self.prop = prop
    }
}

public class RelativeParams {
    var condList: [RelativeCondition] = []

}


public class RelativeLayout: UIView {

    public override func layoutSubviews() {


    }
}