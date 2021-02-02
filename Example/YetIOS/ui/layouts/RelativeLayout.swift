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
    public var prop: RelativeProp
    public var relation: RelativeRelation
    public var other: String?
    public var propOther: RelativeProp?
    public var multiplier: CGFloat
    public var constant: CGFloat

    public init(prop: RelativeProp, relation: RelativeRelation = .eq, other: String? = nil, propOther: RelativeProp? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.prop = prop
        self.relation = relation
        self.other = other
        self.propOther = propOther
        self.multiplier = multiplier
        self.constant = constant
    }
}

public class RelativeParams {
    var condList: [RelativeCondition] = []

}

public extension UIView {
    var relativeParams: RelativeParams? {
        get {
            return getAttr("__relativeParam__") as? RelativeParams
        }
        set {
            setAttr("__relativeParam__", newValue)
        }
    }

    var relativeParamsEnsure: RelativeParams {
        if let L = self.relativeParams {
            return L
        } else {
            let a = RelativeParams()
            self.relativeParams = a
            return a
        }
    }

    func relativeParams(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let ls: [RelativeCondition] = block().itemsTyped()
        self.relativeParamsEnsure.condList.append(contentsOf: ls)
        return self
    }


}

public class RelativeLayout: UIView {

    public override func layoutSubviews() {


    }
}