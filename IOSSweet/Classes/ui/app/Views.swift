//
// Created by entaoyang@163.com on 2017/10/17.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias ViewClickBlock = (UIView) -> Void

//lazy var label: UILabel = NamedView("hello", self)
public func NamedView<T: UIView>(_ page: UIViewController, _ key: String) -> T {
    page.view.findByName(key) as! T
}

public extension UIView {
    var name: String? {
        get {
            self.getAttr("__view_name__") as? String
        }
        set {
            self.setAttr("__view_name__", newValue)
        }
    }

    @discardableResult
    func named(_ name: String) -> Self {
        self.name = name
        return self
    }

    func findByName(_ name: String) -> UIView? {
        if name == self.name {
            return self
        }
        for v in self.subviews {
            if let a = v.findByName(name) {
                return a
            }
        }
        return nil
    }
}

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
    func contentMode(_ m: UIView.ContentMode) -> Self {
        self.contentMode = m
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
    func translatesAutoresizingMaskIntoConstraints(_ b: Bool) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = b
        return self
    }

}

public extension UIView {


    static var SepratorLine: UIView {
        let v = UIView(frame: Rect.zero)
        v.backgroundColor = Colors.seprator
        return v
    }


    func findChildView(_ block: (UIView) -> Bool) -> UIView? {
        for v in self.subviews {
            if block(v) {
                return v
            }
            if let vv = v.findChildView(block) {
                return vv
            }
        }
        return nil
    }

    func addSepratorLine(_ leftOffset: CGFloat = 0, _ rightOffset: CGFloat = 0) -> UIView {
        let line = UIView(frame: Rect.zero)
        line.backgroundColor = Colors.seprator
        self.addSubview(line)
        line.layout.height(1).fillX(leftOffset, rightOffset)
        return line
    }

    func addLineBottom() {
        let line = UIView(frame: Rect.zero)
        line.backgroundColor = Colors.seprator
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
        let w = UIApplication.shared.keyWindow
        return self.convert(self.bounds, to: w)
    }

    func removeAllChildView() {
        let arr = self.subviews
        for v in arr {
            v.removeFromSuperview()
        }
    }

    func roundLayer(_ cornerRadius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }

    func borderLayer(_ borderWidth: CGFloat, color: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }

    func roundBorder(_ corner: CGFloat, _ border: CGFloat, _ borderColor: UIColor) -> UIView {
        self.roundLayer(corner)
        self.borderLayer(border, color: borderColor)
        return self
    }

    func roundBorder() {
        _ = roundBorder(4, 1, Theme.grayBackColor)
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

    func shadow(_ color: UIColor, _ offset: CGSize, _ opacity: Float, _ radius: CGFloat) -> UIView {
        let lay: CALayer = self.layer
        lay.shadowColor = color.cgColor
        lay.shadowOffset = offset
        lay.shadowOpacity = opacity
        lay.shadowRadius = radius
        //		lay.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).CGPath
        return self
    }

    func shadow(offset: CGFloat) {
        _ = shadow(UIColor.black, Size.sized(offset, offset), 0.6, offset)
    }


}
