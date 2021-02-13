//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
open class SelectPage: TablePage {
	public var checkedItem: Any? = nil

	public var bindBlock: (Any) -> String = {
		"\($0)"
	}

	public var resultBlock: (Any) -> Void = {
		logd("\($0)")
	}
	public var equalBlock: ((Any, Any) -> Bool)? = nil

	private func isEqualItem(_ first: Any, _ second: Any) -> Bool {
		return self.equalBlock?(first, second) ?? (self.bindBlock(first) == self.bindBlock(second))
	}

	open override func onCreateContent() {
		super.onCreateContent()
		self.rowHeight = 50
		titleBar.back()
		titleBar.title = "选择"
//		titleBar.rightText(text: "确定")
	}

	open override func onItemClick(_ model: Any) {
		self.checkedItem = model
//		self.tableView.reloadData()
		self.close()
		resultBlock(model)
	}

//	override func onTitleBarAction(sender: UIBarButtonItem, tags: String) {
//		if tags == "确定" {
//			if let c = checkedItem {
//				self.close()
//				resultBlock(c)
//			}
//			return
//		}
//		super.onTitleBarAction(sender: sender, tags: tags)
//	}

	open override func onBindCell(_ model: Any, _ view: UITableViewCell) {
		let s = bindBlock(model)
		view.textLabel?.text = s
		view.textLabel?.textColor = Theme.Text.primaryColor
		if let c = checkedItem, isEqualItem(c, model) {
			view.accessoryType = .checkmark
		} else {
			view.accessoryType = .none
		}
	}

	open override func onNewCell(_ reuse: String) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: reuse)

		return cell
	}
}