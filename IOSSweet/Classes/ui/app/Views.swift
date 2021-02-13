//
// Created by entaoyang@163.com on 2017/10/17.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet






public extension UIView {

    @discardableResult
    func backColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }

    @discardableResult
    func tag(_ n: Int) -> Self {
        self.tag = n
        return self
    }

    @discardableResult
    func clipsToBounds(_ b: Bool) -> Self {
        self.clipsToBounds = b
        return self
    }

    @discardableResult
    func alpha(_ a: CGFloat) -> Self {
        self.alpha = a
        return self
    }

    @discardableResult
    func opaque(_ b: Bool) -> Self {
        self.isOpaque = b
        return self
    }

    @discardableResult
    func hidden(_ b: Bool) -> Self {
        self.isHidden = b
        return self
    }


    @discardableResult
    func tintColor(_ c: UIColor) -> Self {
        self.tintColor = c
        return self
    }

    @discardableResult
    func tintAdjustmentMode(_ m: UIView.TintAdjustmentMode) -> Self {
        self.tintAdjustmentMode = m
        return self
    }

    @discardableResult
    func translatesAutoresizeIntoConstraints(_ b: Bool) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = b
        return self
    }

    @discardableResult
    func contMode(_ m: UIView.ContentMode) -> Self {
        self.contentMode = m
        return self
    }

}

public extension UIView {


    static var SepratorLine: UIView {
        let v = UIView(frame: Rect.zero)
        v.backgroundColor = Colors.separator
        return v
    }


    func addSepratorLine(_ leftOffset: CGFloat = 0, _ rightOffset: CGFloat = 0) -> UIView {
        let line = UIView(frame: Rect.zero)
        line.backgroundColor = Colors.separator
        self.addSubview(line)
        line.layout.height(1).fillX(leftOffset, rightOffset)
        return line
    }

    func addLineBottom() {
        let line = UIView(frame: Rect.zero)
        line.backgroundColor = Colors.separator
        self.addSubview(line)
        line.layout.height(1).fillX().bottomParent(0)
    }

    func findMyController() -> UIViewController? {
        var r: UIResponder? = self
        while r != nil {
            r = r?.next
            if r is UIViewController {
                return r as? UIViewController
            }
        }
        return nil
    }

    func findAllEdit(array: inout Array<UITextField>) {
        for v in self.subviews {
            if v.isKind(of: UITextField.self) {
                array.append(v as! UITextField)
            } else {
                v.findAllEdit(array: &array)
            }
        }
    }

    func findActiveEdit() -> UITextField? {
        var ls = [UITextField]()
        self.findAllEdit(array: &ls)
        for ed in ls {
            if ed.isEditing {
                return ed
            }
        }
        return nil
    }

    func findNextEdit(edit: UITextField) -> UITextField? {
        let rect = edit.screenFrame
        var ls = [UITextField]()
        self.findAllEdit(array: &ls)
        var nearEdit: UITextField? = nil
        var spaceY: CGFloat = 10000
        for ed in ls {
            if ed != edit {
                let r = ed.screenFrame
                let ySpace = r.origin.y - rect.origin.y
                if ySpace >= 0 {
                    if ySpace < spaceY {
                        nearEdit = ed
                        spaceY = ySpace
                    }
                }
            }
        }
        return nearEdit
    }

    var screenFrame: CGRect {
        let w = UIApplication.shared.keyWindowFirst
        return self.convert(self.bounds, to: w)
    }

    func removeAllChildView() {
        let arr = self.subviews
        for v in arr {
            v.removeFromSuperview()
        }
    }

    @discardableResult
    func roundLayer(_ cornerRadius: CGFloat) -> Self {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    func borderLayer(_ borderWidth: CGFloat, color: UIColor) -> Self {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
        return self
    }

    @discardableResult
    func roundBorder(_ corner: CGFloat, _ border: CGFloat, _ borderColor: UIColor) -> Self {
        self.roundLayer(corner)
        return self.borderLayer(border, color: borderColor)
    }

    @discardableResult
    func roundBorder() -> Self {
        roundBorder(4, 1, Theme.grayBackColor)
    }

    func dotBorder(_ corner: CGFloat, _ color: Color, _ pattern: [NSNumber]) {
        let v: UIView = self
        let lay = CAShapeLayer()
        lay.strokeColor = color.cgColor
        lay.fillColor = Color.clear.cgColor
        let path = UIBezierPath(roundedRect: v.bounds, cornerRadius: corner)
        lay.path = path.cgPath
        lay.frame = v.bounds
        lay.lineWidth = 1
        lay.lineDashPattern = pattern
        v.layer.cornerRadius = corner
        v.layer.masksToBounds = true
        v.layer.addSublayer(lay)
        logd(v.bounds)
    }

    @discardableResult
    func shadow(_ color: UIColor, _ offset: CGSize, _ opacity: Float, _ radius: CGFloat) -> Self {
        let lay: CALayer = self.layer
        lay.shadowColor = color.cgColor
        lay.shadowOffset = offset
        lay.shadowOpacity = opacity
        lay.shadowRadius = radius
        //		lay.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).CGPath
        return self
    }

    @discardableResult
    func shadow(offset: CGFloat) -> Self {
        shadow(UIColor.black, Size.sized(offset, offset), 0.6, offset)
    }


}

