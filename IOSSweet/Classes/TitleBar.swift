//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
public class TitleBar {
	public unowned var controller: UIViewController

	private(set) public var hasBack = false

	public init(_ c: UIViewController) {
		self.controller = c
	}
}

public extension TitleBar {

	var nav: UINavigationItem? {
		return self.controller.navigationItem
	}

	var height: CGFloat {
		if let b = self.controller.navigationController?.navigationBar {
			return b.isHidden ? 0 : b.frame.height
		}
		return 0
	}

	var title: String? {
		get {
			return self.nav?.title
		}
		set {
			self.nav?.title = newValue
		}
	}

	@discardableResult
	func leftText(text: String) -> UIBarButtonItem {
		let b = leftText(text: text, target: self, action: #selector(onItemClick(id:)))
		b.tagS = text
		return b
	}

	@discardableResult
	func rightText(text: String) -> UIBarButtonItem {
		let b = rightText(text: text, target: self, action: #selector(onItemClick(id:)))
		b.tagS = text
		return b
	}

	@discardableResult
	func leftImage(image: String) -> UIBarButtonItem {
		let b = leftImage(imageName: image, target: self, action: #selector(onItemClick(id:)))
		b.tagS = image
		return b
	}

	@discardableResult
	func rightImage(image: String) -> UIBarButtonItem {
		let b = rightImage(imageName: image, target: self, action: #selector(onItemClick(id:)))
		b.tagS = image
		return b
	}

	func leftText(text: String, block: @escaping ActionBlock) {
		let ab = TargetSelector(block)
		let b = self.leftText(text: text, target: ab, action: ab.selector)
		b.targetSelector = ab
	}

	func rightText(text: String, block: @escaping ActionBlock) {
		let ab = TargetSelector(block)
		let b = self.rightText(text: text, target: ab, action: ab.selector)
		b.targetSelector = ab
	}

	@discardableResult
	func leftText(text: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
		let b = TitleBar.makeTextButton(text: text, target: target, action: action)
		var ls = self.nav?.leftBarButtonItems ?? [UIBarButtonItem]()
		ls.append(b)
		self.nav?.leftBarButtonItems = ls
		return b
	}

	@discardableResult
	func rightText(text: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
		let b = TitleBar.makeTextButton(text: text, target: target, action: action)
		var ls = self.nav?.rightBarButtonItems ?? [UIBarButtonItem]()
		ls.append(b)
		self.nav?.rightBarButtonItems = ls
		return b
	}

	func leftImage(imageName: String, block: @escaping ActionBlock) {
		let ab = TargetSelector(block)
		let b = self.leftImage(imageName: imageName, target: ab, action: ab.selector)
		b.targetSelector = ab
	}

	func rightImage(imageName: String, block: @escaping ActionBlock) {
		let ab = TargetSelector(block)
		let b = self.rightImage(imageName: imageName, target: ab, action: ab.selector)
		b.targetSelector = ab
	}

	@discardableResult
	func leftImage(imageName: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
		let b = TitleBar.makeImageButton(imageName: imageName, target: target, action: action)
		var ls = self.nav?.leftBarButtonItems ?? [UIBarButtonItem]()
		ls.append(b)
		self.nav?.leftBarButtonItems = ls
		return b
	}

	@discardableResult
	func rightImage(imageName: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
		let b = TitleBar.makeImageButton(imageName: imageName, target: target, action: action)
		var ls = self.nav?.rightBarButtonItems ?? [UIBarButtonItem]()
		ls.append(b)
		self.nav?.rightBarButtonItems = ls
		return b
	}

	func back(target: AnyObject, action: Selector) {
		if hasBack {
			return
		}
		hasBack = true
		if TitleBar.BackImageCustom.isEmpty {
			let s = resOf(cls: TitleBar.self, res: TitleBar.BackImage)
			self.leftImage(imageName: s, target: target, action: action)
		} else {
			let s = resMain(TitleBar.BackImageCustom)
			self.leftImage(imageName: s, target: target, action: action)
		}

	}

	func back() {
		self.back(target: self, action: #selector(onBackClick(id:)))
	}

	@objc
	func onItemClick(id: UIBarButtonItem) {
		if let c = controller as? BasePage {
			c.onTitleBarAction(sender: id, tags: id.tagS)
		}
	}

	@objc
	func onBackClick(id: UIBarButtonItem) {
		if let c = controller as? BasePage {
			c.onTitleBarBack()
		}
	}

	private static var BackImage = "yet_ui_back"
	static var BackImageCustom = ""

	static func makeTextButton(text: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
		let b = UIBarButtonItem(title: text, style: UIBarButtonItem.Style.plain, target: target, action: action)
		b.setTitleTextAttributes([
			NSAttributedString.Key.foregroundColor: Color.white,
			NSAttributedString.Key.font: Fonts.regular(14)
		], for: UIControl.State.normal)
		return b
	}

	static func makeImageButton(imageName: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
		let b = UIBarButtonItem(image: UIImage(named: imageName)?.scaledTo(25), style: UIBarButtonItem.Style.plain, target: target, action: action)
		return b
	}
}