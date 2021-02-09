//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {


    static var RedRound: UIButton {
        let b = UIButton(frame: Rect.zero)
        b.roundMax().themeDanger()
        b.titleLabel?.font = Fonts.semibold(16)
        return b
    }
    static var GreenRound: UIButton {
        let b = UIButton(frame: Rect.zero)
        b.roundMax().themeSafe()
        b.titleLabel?.font = Fonts.semibold(16)
        return b
    }
    static var Default: UIButton {
        let b = UIButton(type: .roundedRect)
        b.titleLabel?.font = Fonts.semibold(16)
        return b
    }

    var title: String? {
        get {
            return self.title(for: .normal)
        }
        set {
            self.setTitle(newValue, for: .normal)
        }
    }

    var titleColor: UIColor? {
        get {
            return self.titleColor(for: .normal)
        }
        set {
            self.setTitleColor(newValue, for: .normal)
        }
    }
    var image: UIImage? {
        get {
            return self.image(for: .normal)
        }
        set {
            self.setImage(newValue, for: .normal)
        }
    }

    func titleColor(_ c: UIColor) -> Self {
        self.titleColor = c
        return self
    }

    func title(_ s: String) -> Self {
        self.title = s
        return self
    }

    func textColorWhite() -> Self {
        self.setTitleColor(Color.white, for: UIControl.State.normal)
        return self
    }

    func textColorPrimary() -> Self {
        self.setTitleColor(Theme.Text.primaryColor, for: UIControl.State.normal)
        return self
    }

    @discardableResult
    func rounded(_ corner: CGFloat = Theme.Button.roundCorner) -> Self {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corner
        return self
    }

    @discardableResult
    func roundMax() -> Self {
        return self.rounded(Theme.Button.heightLarge / 2)
    }

    @discardableResult
    func bordered(_ borderColor: UIColor) -> Self {
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        return self
    }

    @discardableResult
    func theme(_ textColor: Color, _ backColor: Color) -> Self {
        self.setTitleColor(textColor, for: UIControl.State.normal)
        self.setTitleColor(Theme.Text.disabledColor, for: UIControl.State.disabled)

        self.setBackgroundImage(Image.colored(backColor, 1, 1), for: UIControl.State.normal)
        self.setBackgroundImage(Image.colored(Theme.Button.disabledColor, 1, 1), for: UIControl.State.disabled)
        return self
    }

    @discardableResult
    func themeWhite() -> Self {
        self.theme(Theme.Button.textColor, Theme.Button.backColor)
        self.rounded()
        self.bordered(Theme.Button.borderColor)
        return self
    }

    @discardableResult
    func themeDanger() -> Self {
        self.theme(UIColor.white, Theme.dangerColor)
        return self
    }

    @discardableResult
    func themeSafe() -> Self {
        self.theme(UIColor.white, Theme.safeColor)
        return self
    }
}