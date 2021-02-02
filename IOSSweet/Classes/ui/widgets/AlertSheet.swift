//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UIAlertAction {

	func titleTextColor(_ c: UIColor) {
		self.setValue(c, forKey: "titleTextColor")
	}

	func setImage(_ img: UIImage) {
		let m = img.scaledTo(36).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
		self.setValue(m, forKey: "image")
	}

	func textAlignLeft() {
//		self.setValue(CATextLayerAlignmenetMode.left, forKey: "titleTextAlignment")
//		self.setValue(kCAAlignmentLeft, forKey: "titleTextAlignment")
	}
}

public class AlertSheet {
	public var superPage: UIViewController
	public var actionItems = [(text: String, type: UIAlertAction.Style)]()

	public init(_ superPage: UIViewController) {
		self.superPage = superPage
	}
}

public extension AlertSheet {

	@discardableResult
	func show(_ block: @escaping (String) -> Void) -> UIAlertController {
		let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		ac.view.superview?.clickView { v in
			logd("click view ")
			v.findMyController()?.close()
		}

		let actionBlock: (UIAlertAction) -> Void = { aa in
			if aa.style != .cancel {
				block(aa.title!)
			}
		}
		actionItems.forEach { (text, type) in
			ac.addAction(UIAlertAction(title: text, style: type, handler: actionBlock))
		}
		self.superPage.present(ac, animated: true)
		return ac
	}

	func actions(_ items: [String]) -> AlertSheet {
		for s in items {
			self.action(s)
		}
		return self
	}

	@discardableResult
	func action(_ title: String, _ style: UIAlertAction.Style) -> AlertSheet {
		actionItems.append((title, style))
		return self
	}

	@discardableResult
	func action(_ title: String) -> AlertSheet {
		return action(title, .default)
	}

	@discardableResult
	func risk(_ title: String) -> AlertSheet {
		return action(title, .destructive)
	}

	@discardableResult
	func cancel(_ title: String = "取消") -> AlertSheet {
		return action(title, .cancel)
	}

}

public class AlertList {
	public var superPage: UIViewController
	public var actionItems = [UIAlertAction]()

	public init(_ superPage: UIViewController) {
		self.superPage = superPage
	}
}

public extension AlertList {

	@discardableResult
	func show() -> UIAlertController {
		let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		ac.view.superview?.clickView { v in
			v.findMyController()?.close()
		}
		for b in self.actionItems {
			ac.addAction(b)
		}
		self.superPage.present(ac, animated: true)
		return ac
	}

	@discardableResult
	func actions(_ items: [String], _ block: @escaping (String) -> Void) -> AlertList {
		for s in items {
			self.action(s, { block(s) })
		}
		return self
	}

	@discardableResult
	func action(_ title: String, _ style: UIAlertAction.Style, _ block: @escaping () -> Void) -> AlertList {
		actionItems.append(UIAlertAction(title: title, style: style, handler: { _ in block() }))
		return self
	}

	@discardableResult
	func action(_ title: String, _ block: @escaping () -> Void) -> AlertList {
		return self.action(title, .default, block)
	}

	@discardableResult
	func risk(_ title: String, _ block: @escaping () -> Void) -> AlertList {
		return self.action(title, .destructive, block)
	}

	@discardableResult
	func cancel(_ title: String = "取消") -> AlertList {
		return action(title, .cancel, {})
	}

}

