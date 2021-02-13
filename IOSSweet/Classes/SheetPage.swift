//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
//TODO use button
open class SheetAction: UIView {
	public var textView: UILabel = UILabel.Primary
	public var iconView: UIImageView = UIImageView.Default
	public var actionBlock: BlockVoid = {
	}

	public init() {
		super.init(frame: Rect.zero)
		self.backgroundColor = Color.white
		self.addSubview(iconView)
		self.addSubview(textView)
		iconView.layout.leftParent(Dim.sep).size(Dim.iconSize).centerYParent()
		textView.layout.toRightOf(iconView, Dim.sep).centerYParent().heightEdit().rightParent()

		self.clickView { [weak self] c in
			if let me = self {
				me.findMyController()?.close()
				me.actionBlock()
				me.actionBlock = {
				}
			}
		}
		self.setupFeedback()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

open class SheetPage: BasePage {
	public weak var superPage: UIViewController? = nil

	public var sheets = [SheetAction]()

	public var height: CGFloat = 60

	public var gravityCenter = false
	public var tintThemeColor = true

	public init(_ superPage: UIViewController) {
		super.init(nibName: nil, bundle: nil)
		self.modalPresentationStyle = .overFullScreen
		self.modalTransitionStyle = .crossDissolve
		self.superPage = superPage
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Color.clear

		let ls = sheets.reversed()

		var i = 0
		for a: SheetAction in ls {
			self.view.addSubview(a)
			a.layout.fillX().height(height).bottomParent(-height * CGFloat(i))
			if i != 0 {
				a.addLineBottom()
			}

			i = i + 1
		}

//		let first = sheets.first!
//		let v = UIView(frame: Rect.zero)
//		v.backgroundColor = Color.rgba(0, 0, 0, 125)
//		self.view.addSubview(v)
//		v.layout.fillX().topParent(0).above(first)
//		v.clickView { v in
//			v.findMyController()?.close()
//		}

		self.view.clickView { v in
			v.findMyController()?.close()
		}

	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.view.backgroundColor = Color.rgba(0, 0, 0, 40)
	}

	open override func viewWillDisappear(_ animated: Bool) {
		self.view.backgroundColor = .clear
		super.viewWillDisappear(animated)
	}

	@discardableResult
	open func addAction(_ text: String, _ image: String, _ block: @escaping BlockVoid) -> SheetAction {
		let a = self.addAction(text, block)
		if self.tintThemeColor {
			a.iconView.nameThemed(image)
		} else {
			a.iconView.namedImage(image)
		}
		return a
	}

	@discardableResult
	open func addAction(_ text: String, _ block: @escaping BlockVoid) -> SheetAction {
		let a = SheetAction()
		addAction(a)
		a.textView.text = text
		a.actionBlock = block
		return a
	}

	@discardableResult
	open func addAction(_ a: SheetAction) -> SheetAction {
		sheets.append(a)
		return a
	}

	open func show() {
		self.superPage?.present(self)
	}

}