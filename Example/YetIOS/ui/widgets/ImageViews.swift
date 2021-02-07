//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

//import Kingfisher

public extension UIImageView {

    static var makeDefault: UIImageView {
        return UIImageView.Default
    }
    static var Default: UIImageView {
        let v = UIImageView(frame: Rect.zero)
        v.scaleAspectFill()
        v.clipsToBounds = true
        return v
    }

    @discardableResult
    func nameThemed(_ name: String) -> Self {
        self.image = UIImage(named: name)?.tinted(Theme.themeColor)
        return self
    }

    @discardableResult
    func namedImage(_ name: String) -> Self {
        self.image = UIImage(named: name)
        return self
    }

    @discardableResult
    func namedImage(_ name: String, _ w: CGFloat) -> Self {
        self.image = UIImage(named: name)?.scaledTo(w)
        return self
    }


    @discardableResult
    func scaleAspectFill() -> Self {
        self.contentMode = .scaleAspectFill
        return self
    }

    @discardableResult
    func mode(_ m: UIView.ContentMode) -> Self {
        self.contentMode = m
        return self
    }
}