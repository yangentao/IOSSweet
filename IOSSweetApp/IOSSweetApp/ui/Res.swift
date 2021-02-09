//
// Created by entaoyang@163.com on 2019/9/20.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation
import UIKit

//public func resOf(cls: AnyClass, res: String) -> String {
//	if res.hasPrefix("/") {
//		return res
//	}
//	return Bundle(for: cls).bundlePath.appendPath(res)
//}
//
//public func resMain(_ res: String) -> String {
//	if res.hasPrefix("/") {
//		return res
//	}
//	return Bundle.main.bundlePath.appendPath(res)
//}

struct Res: Hashable, Equatable, RawRepresentable {
	var rawValue: String

	init(rawValue: String) {
		self.rawValue = rawValue
	}

	init(_ value: String) {
		self.rawValue = value
	}

	var value: String {
		self.rawValue
	}
}

//extension Lang {
//	static let ok = Lang("ok")
//}
struct Lang: Hashable, Equatable, RawRepresentable {
	var rawValue: String

	init(rawValue: String) {
		self.rawValue = rawValue
	}

	init(_ value: String) {
		self.rawValue = value
	}

	var value: String {
		NSLocalizedString(self.rawValue, comment: "")
	}

}

extension UILabel {
	var textValue: Lang {
		get {
			Lang(self.text ?? "")
		}
		set {
			self.text = newValue.value
		}
	}
	//var hintText: Lang {
	//	get {
	//		Lang(self.plac ?? "")
	//	}
	//	set {
	//		self.placeholderString = newValue.value
	//	}
	//}
}

extension UIButton {

	func setTitle(text: Lang, for state: UIControl.State) {
		self.setTitle(text.value, for: state)
	}

	func setImage(res: Res, for state: UIControl.State) {
		self.setImage(UIImage(named: res.value), for: state)
	}

}

extension UIImage {
	convenience init(res: Res) {
		self.init(named: res.value)!
	}
}