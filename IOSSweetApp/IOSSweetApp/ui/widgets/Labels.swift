//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {

    static var makePrimary: UILabel {
        return UILabel.Primary
    }
    static var makeMinor: UILabel {
        return UILabel.Minor
    }

    static var Primary: UILabel {
        let a = UILabel(frame: Rect.zero)
        a.stylePrimary()
        return a
    }
    static var Minor: UILabel {
        let a = UILabel(frame: Rect.zero)
        a.styleMinor()
        return a
    }

    @discardableResult
    func styleMinor() -> Self {
        self.textColor = Theme.Text.minorColor
        self.font = Theme.Text.minorFont
        return self
    }

    @discardableResult
    func stylePrimary() -> Self {
        self.textColor = Theme.Text.primaryColor
        self.font = Theme.Text.primaryFont
        return self
    }

    var heightThatFit: CGFloat {
        let sz = self.sizeThatFits(Size.zero)
        return sz.height
    }
    var widthThatFit: CGFloat {
        let sz = self.sizeThatFits(Size.zero)
        return sz.width
    }


    @discardableResult
    func align(_ a: NSTextAlignment) -> Self {
        self.textAlignment = a
        return self
    }

    @discardableResult
    func lines(_ n: Int) -> Self {
        self.numberOfLines = n
        return self
    }

    @discardableResult
    func text(_ s: String?) -> Self {
        self.text = s
        return self
    }

    @discardableResult
    func font(_ f: UIFont) -> Self {
        self.font = f
        return self
    }


    @discardableResult
    func textColor(_ c: UIColor) -> Self {
        self.textColor = c
        return self
    }

    @discardableResult
    func shadowColor(_ c: UIColor?) -> Self {
        self.shadowColor = c
        return self
    }

    @discardableResult
    func shadowOffset(_ s: CGSize) -> Self {
        self.shadowOffset = s
        return self
    }

    @discardableResult
    func lineBreakMode(_ m: NSLineBreakMode) -> Self {
        self.lineBreakMode = m
        return self
    }

    @discardableResult
    func attributedText(_ s: NSAttributedString?) -> Self {
        self.attributedText = s
        return self
    }

    @discardableResult
    func highlightedTextColor(_ c: UIColor?) -> Self {
        self.highlightedTextColor = c
        return self
    }

    @discardableResult
    func highlighted(_ b: Bool) -> Self {
        self.isHighlighted = b
        return self
    }

    @discardableResult
    func userInteractionEnabled(_ b: Bool) -> Self {
        self.isUserInteractionEnabled = b
        return self
    }

    @discardableResult
    func enabled(_ b: Bool) -> Self {
        self.isEnabled = b
        return self
    }

    @discardableResult
    func adjustsFontSizeToFitWidth(_ b: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = b
        return self
    }

    @discardableResult
    func minimumScaleFactor(_ f: CGFloat) -> Self {
        self.minimumScaleFactor = f
        return self
    }

    @discardableResult
    func allowsDefaultTighteningForTruncation(_ b: Bool) -> Self {
        self.allowsDefaultTighteningForTruncation = b
        return self
    }

    @discardableResult
    func lineBreakStrategy(_ s: NSParagraphStyle.LineBreakStrategy) -> Self {
        self.lineBreakStrategy = s
        return self
    }


}