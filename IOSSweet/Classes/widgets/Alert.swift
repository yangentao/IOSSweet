//
// Created by entaoyang@163.com on 2017/10/16.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UIAlertController {
	var textArray: [String] {
		return self.textFields?.map {
			$0.text ?? ""
		} ?? [String]()
	}
	var textFirst: String? {
		return textArray.first
	}
	var textSecond: String? {
		let arr = textArray
		if arr.count > 1 {
			return arr[1]
		}
		return nil
	}
}

public class AlertResult: CustomStringConvertible {
	var action: String = ""
	var textArray = [String]()

	public var description: String {
		return "Action:\(action) , Texts:\(textArray)"
	}
}

public class Alert {
	public var superPage: UIViewController
	public var actionItems = [(text: String, type: UIAlertAction.Style)]()
	public var style: UIAlertController.Style = .alert

	public var title: String? = nil
	public var message: String? = nil
	//hint -> text
	public var textFiels = [(hint: String, text: String)]()

	public init(_ superPage: UIViewController) {
		self.superPage = superPage
	}
}

public extension Alert {

	var sheet: Alert {
		style = .actionSheet
		return self
	}

	func showConfirm(title: String?, msg: String?, onOK: @escaping () -> Void) {
		self.title(title).message(msg).cancel("取消").action("确定").show { ar in
			onOK()
		}
	}

	func showAlert(title: String?, msg: String?, action: String = "确定") {
		self.title(title).message(msg).cancel(action).show { _ in
		}
	}

	@discardableResult
	func show(_ block: @escaping (AlertResult) -> Void) -> UIAlertController {
		let ac = UIAlertController(title: self.title, message: self.message, preferredStyle: style)
		textFiels.forEach { (hint, text) in
			ac.addTextField { edit in
				edit.placeholder = hint
				edit.text = text
				edit.clearButtonMode = .always
			}
		}

		let actionBlock: (UIAlertAction) -> Void = { aa in
			if aa.style != .cancel {
				let ar = AlertResult()
				ar.action = aa.title!
				ar.textArray = ac.textArray
				block(ar)
			}
		}
		actionItems.forEach { (text, type) in
			ac.addAction(UIAlertAction(title: text, style: type, handler: actionBlock))
		}

		self.superPage.present(ac, animated: true)
		return ac
	}

	@discardableResult
	func title(_ title: String?) -> Alert {
		self.title = title
		return self
	}

	@discardableResult
	func message(_ msg: String?) -> Alert {
		self.message = msg
		return self
	}

	@discardableResult
	func textField(_ hint: String, _ text: String = "") -> Alert {
		textFiels.append((hint, text))
		return self
	}

	@discardableResult
	func actions(_ titles: [String]) -> Alert {
		for s in titles {
			_ = action(s)
		}
		return self
	}

	@discardableResult
	func action(_ title: String, _ style: UIAlertAction.Style) -> Alert {
		actionItems.append((title, style))
		return self
	}

	@discardableResult
	func action(_ title: String) -> Alert {
		return action(title, .default)
	}

	@discardableResult
	func risk(_ title: String) -> Alert {
		return action(title, .destructive)
	}

	@discardableResult
	func cancel(_ title: String = "取消") -> Alert {
		return action(title, .cancel)
	}

}
