//
// Created by entaoyang@163.com on 2017/10/14.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class WatchItem: Equatable {
	public weak var item: NSObject?
	public var propName: String = ""
	public var fireMsg: String = ""
	public weak var layoutView: UIView?
	public var layoutSuper: Bool = false

	public init(obj: NSObject, prop: String) {
		self.item = obj
		self.propName = prop
	}

	@discardableResult
	public func fire(_ msg: String) -> WatchItem {
		fireMsg = msg
		return self
	}

	@discardableResult
	public func layout(_ view: UIView) -> WatchItem {
		layoutView = view
		return self
	}

	@discardableResult
	public func layoutSuperView() -> WatchItem {
		layoutSuper = true
		return self
	}

	fileprivate func isMsg(_ m: String) -> Bool {
		return self.fireMsg == m
	}

	public static func ==(lhs: WatchItem, rhs: WatchItem) -> Bool {
		if lhs === rhs {
			return true
		}
		if lhs.propName == rhs.propName {
			if let a = lhs.item, let b = rhs.item, a === b {
				return true
			}
		}
		return false
	}
}

public class ObjectWatch: NSObject {

	fileprivate var all = Array<WatchItem>()

	deinit {
		for item in all {
			item.item?.removeObserver(self, forKeyPath: item.propName)
		}
		all.removeAll()
	}

	public func watch(obj: NSObject, property: String) -> WatchItem {
		let item = WatchItem(obj: obj, prop: property)
		all.append(item)
		item.item?.addObserver(self, forKeyPath: item.propName, options: [.new], context: nil)
		return item
	}

	public func remove(obj: NSObject, _ property: String) {
		obj.removeObserver(self, forKeyPath: property)
		sync(self) {
			_ = all.drop {
				return $0.item === obj && $0.propName == property
			}
		}
	}

	public func remove(obj: NSObject) {
		sync(self) {
			_ = all.drop {
				if $0.item === obj {
					obj.removeObserver(self, forKeyPath: $0.propName)
					return true
				}
				return false
			}
		}
	}

	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if let kp = keyPath, let obj = object as? NSObject {
			sync(self) {
				all.filter { item in
					return item.item === obj && item.propName == kp
				}.forEach { item in
					if !item.fireMsg.isEmpty {
						MsgID(item.fireMsg).fire()
					}
					if let v = item.layoutView {
						v.setNeedsLayout()
					}
					if item.layoutSuper {
						if let v = item.item as? UIView {
							v.superview?.setNeedsLayout()
						}
					}
				}

				_ = all.drop { item in
					return item.item == nil
				}
			}
		}

	}
}

public let WatchCenter = ObjectWatch()