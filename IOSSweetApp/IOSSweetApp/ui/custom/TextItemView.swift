//
// Created by yangentao on 2021/2/7.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

open class TextItemView: UILabel {
    public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}