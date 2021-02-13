//
// Created by entaoyang on 2019-01-16.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
open class TablePage: TitlePage, UITableViewDataSource, UITableViewDelegate {
	public var tableView: UITableView = UITableView(frame: Rect.zero, style: .plain)

	public var reuseId = "0"
	private var itemsData: [Any] = [Any]()

	public var tableTopOffset: CGFloat = 0
	public var tableBottomOffset: CGFloat = 0
	public var rowHeight: CGFloat = 70
	public var enablePullRefresh = false {
		willSet {
			if newValue {
				tableView.addPullRefresh { [weak self] in
					self?.requestItems()
				}
			}
		}
	}

	open override func onCreateContent() {
		super.onCreateContent()
		self.tableView.backgroundColor = Color.white
		self.tableView.delegate = self
		self.tableView.dataSource = self
		contentView.addSubview(tableView)
		tableView.layout.fillX().topParent(self.tableTopOffset).bottomParent(-self.tableBottomOffset)
		tableView.tableFooterView = UIView(frame: Rect.zero)
		tableView.allowsMultipleSelection = false
	}

	deinit {
		tableView.removePullRefresh()
		logd("Table Page deinit ", self.tabBarItem.title, self)
	}

	open func onNewCell(_ reuse: String) -> UITableViewCell {
		return UITableViewCell(style: .default, reuseIdentifier: self.reuseId)
	}

	open func onBindCell(_ model: Any, _ view: UITableViewCell) {
		view.textLabel?.text = "\(model)"
		view.textLabel?.textColor = Theme.Text.primaryColor
	}

	open func onItemClick(_ model: Any) {

	}

	open func onItemLongClick(_ model: Any) {

	}

	open func setItems(_ data: [Any]) {
		self.itemsData = data
		self.tableView.reloadData()
	}

	open func getItem(_ n: Int) -> Any {
		return self.itemsData[n]
	}

	open func requestItems() {
		Task.fore {
			self.showIndicator()
		}
		Task.back {
			let a = self.onRequestItems()
			Task.fore {
				self.tableView.pullView?.stopLoading()
				self.setItems(a)
				self.hideIndicator()
			}
		}
	}

	open func onRequestItems() -> [Any] {
		return []
	}

	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.itemsData.count
	}

	open func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = getItem(indexPath.row)
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) ?? onNewCell(reuseId)
		cell.backgroundColor = .white
		onBindCell(item, cell)
		return cell
	}

	@objc
	open func _onLongPress(_ r: UILongPressGestureRecognizer) {
		if r.isBegan {
			let pt = r.location(in: self.tableView)
			if let p = self.tableView.indexPathForRow(at: pt) {
				let item = getItem(p.row)
				self.onItemLongClick(item)
			}
		}

	}

	open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		self.onItemClick(getItem(indexPath.row))
		return nil
	}

	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}

	open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return rowHeight
	}

	open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}

	open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}

	open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return nil
	}

	open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}

}