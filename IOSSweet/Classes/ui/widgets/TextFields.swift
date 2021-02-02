//
// Created by entaoyang@163.com on 2017/10/16.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias EditBlock = (UITextField) -> Void

public extension UITextField {

	static var makeRound: UITextField {
		return UITextField.Round

	}

	static var makeRoundPwd: UITextField {
		return UITextField.RoundPwd

	}

	static var Round: UITextField {
		return  UITextField(frame: Rect.zero).themeRound()
	}
	static var RoundPwd: UITextField {
		let e = UITextField(frame: Rect.zero)
		e.isSecureTextEntry = true
		return e.themeRound()
	}

	var isRequired: Bool {
		return self.placeholder?.endWith("*") ?? false
	}
	var maxLength: Int {
		get {
			return self.getAttr("__textfield.maxLength__") as? Int ?? 0
		}
		set {
			self.setAttr("__textfield.maxLength__", newValue)
		}
	}

	var minLength: Int {
		get {
			return self.getAttr("__textfield.minLength") as? Int ?? 0
		}
		set {
			self.setAttr("__textfield.minLength", newValue)
		}
	}

	var checkValid: Bool {
		let s = textTrim
		if self.isRequired {
			if s.isEmpty {
				self.markError()
				return false
			}
		}
		if self.maxLength > 0 {
			if s.count > self.maxLength {
				self.markError()
				return false
			}
		}
		if self.minLength > 0 {
			if s.count < self.minLength {
				self.markError()
				return false
			}
		}
		return true
	}

	var textTrim: String {
		return text?.trimed ?? ""
	}
	var empty: Bool {
		return self.text?.empty ?? true
	}
	var trimEmpty: Bool {
		return textTrim.empty
	}

	var hintText: String? {
		get {
			return placeholder
		}
		set {
			placeholder = newValue
		}
	}

	@discardableResult
	func hint(_ s: String) -> UITextField {
		self.placeholder = s
		return self
	}

	func textAlignCenter() {
		self.textAlignment = .center
	}

	func textAlignLeft() {
		self.textAlignment = .left
	}

	func textAlignRight() {
		self.textAlignment = .right
	}

	func textColorBlack() {
		self.textColor = UIColor.black
	}

	func textColorWhite() {
		self.textColor = UIColor.white
	}

	func textColorPrimary() {
		self.textColor = Theme.Text.primaryColor
	}

	func markError() {
		self.layer.borderColor = Theme.Edit.borderError.cgColor
	}

	@discardableResult
	func themeRound() -> UITextField {
		self.borderStyle = .roundedRect
		self.layer.borderColor = Theme.Edit.borderNormal.cgColor
		self.layer.borderWidth = 1
		self.layer.cornerRadius = Theme.Edit.corner
		self.layer.masksToBounds = true

		self.backgroundColor = UIColor.white
		self.clearButtonMode = .always
		self.textColor = Theme.Text.primaryColor
		self.leftView = UIView(frame: Rect.sized(10))
		self.leftViewMode = .always
		self.keyboardAppearance = .light
		self.autocapitalizationType = .none
		self.autocorrectionType = .no

		let d = EditEndDelegate()
		self.delegate = d
		self.callbackDelegate = d

		checkPwd()

		return self
	}

	@discardableResult
	func pwd() -> UITextField {
		self.isSecureTextEntry = true
		return self.checkPwd()
	}

	@discardableResult
	func checkPwd() -> UITextField {
		if self.isSecureTextEntry {
			self.clearButtonMode = .never
			let b = UIButton(type: .custom)
			b.image = UIImage(named: "eye")
			b.setImage(UIImage(named: "eye" + Theme.imagePostfix), for: .selected)
			b.frame = Rect(x: 0, y: 0, width: 40, height: 32)
			self.rightView = b
			self.rightViewMode = .always
			b.click(self, #selector(_onClickPwdRightButton(sender:)))
		}
		return self
	}

	@objc
	func _onClickPwdRightButton(sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			self.isSecureTextEntry = false
		} else {
			self.isSecureTextEntry = true
		}
		let s = self.text
		self.text = ""
		self.text = s
	}

	func leftIcon(_ imageName: String) {
		let b = UIButton(frame: Rect(x: 0, y: 0, width: 30, height: 36))
		b.setImage(UIImage(named: imageName), for: .normal)
		b.isUserInteractionEnabled = false
		self.leftView = b
		self.leftViewMode = .always
	}

	var typePassword: UITextField {
		self.isSecureTextEntry = true
		return self
	}

	var typeNumber: UITextField {
		self.keyboardType = .numberPad
		return self
	}

	var typePhone: UITextField {
		self.keyboardType = .phonePad
		return self
	}

	var typeEmail: UITextField {
		self.keyboardType = .emailAddress
		return self
	}

	private func makeReturn(_ returnType: UIReturnKeyType, _ block: @escaping EditBlock) {
		self.returnKeyType = returnType
		if let d = self.callbackDelegate {
			d.returnBlock = block
		}
	}

	func returnDone() {
		makeReturn(.done) { ed in
		}
	}

	func returnGo(_ block: @escaping EditBlock) {
		makeReturn(.go, block)
	}

	func returnNext() {
		self.returnKeyType = .next
	}

	func returnJoin(_ block: @escaping EditBlock) {
		makeReturn(.join, block)
	}

	func returnSearch(_ block: @escaping EditBlock) {
		makeReturn(.search, block)
	}

	func returnSend(_ block: @escaping EditBlock) {
		makeReturn(.send, block)
	}

	func onEndEditing(_ block: @escaping EditBlock) {
		self.callbackDelegate?.endEditBlock = block
	}

	private var callbackDelegate: EditEndDelegate? {
		get {
			return self.getAttr("__doneDelegate__") as? EditEndDelegate
		}
		set {
			self.setAttr("__doneDelegate__", newValue)
		}
	}

}

//注意callback如果用到外部的self, 使用弱引用 [weak self]
public class EditEndDelegate: NSObject, UITextFieldDelegate {

	public var returnBlock: EditBlock = { ed in
	}
	public var endEditBlock: EditBlock = { ed in
	}

	deinit {
		logd("deinit EditEndDelegate")
	}

	public func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.layer.borderColor = Theme.Edit.borderActive.cgColor
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		textField.layer.borderColor = Theme.Edit.borderNormal.cgColor
		self.endEditBlock(textField)
	}

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField.returnKeyType {
		case .done, .go, .search, .send, .join:
			UIWindow.main.endEditing(true)
			returnBlock(textField)
		case .next:
			textField.resignFirstResponder()
			if let ed = textField.findMyController()?.view.findNextEdit(edit: textField) {
				ed.becomeFirstResponder()
			} else {
				UIWindow.main.endEditing(true)
			}
		default:
			break
		}
		return true
	}
}
