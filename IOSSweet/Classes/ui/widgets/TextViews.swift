//
// Created by entaoyang on 2019-02-15.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet

public extension UITextView {

    static var makeDefault: UITextView {
        return UITextView.Default
    }
    static var Default: UITextView {
        let v = UITextView(frame: .zero)
        v.backgroundColor = .white
        v.isEditable = false
        v.textAlignment = .left
        v.font = Fonts.regular(15)
        v.textColor = Theme.Text.primaryColor
        v.textContainerInset = EdgeInset(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }

//    func article(_ text: String) {
//        self.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
//        self.attributedText = styledText(text) { t in
//            t.font(Fonts.regular(16)).foreColor(Theme.Text.primaryColor).paragraphStyle { p in
//                p.lineSpace(8).indent(32)
//            }
//        }
//    }

    @discardableResult
    func themeRound() -> UITextView {
        self.layer.borderColor = Theme.Edit.borderNormal.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = Theme.Edit.corner
        self.layer.masksToBounds = true

        self.backgroundColor = UIColor.white
        self.textColor = Theme.Text.primaryColor
        self.keyboardAppearance = .light
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.font = Fonts.regular(15)
        self.textContainerInset = EdgeInset(top: 10, left: 10, bottom: 10, right: 10)

        return self
    }

    func heightByScreen(_ offset: CGFloat = 0) -> CGFloat {
        return self.sizeThatFits(Size(width: UIScreen.width - offset, height: 0)).height
    }
}