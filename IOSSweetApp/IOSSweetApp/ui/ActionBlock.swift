//
// Created by entaoyang on 2018-12-30.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

//注意 使用 [weak self]
public typealias ActionBlock = (AnyObject) -> Void

public class TargetSelector {
	public var action: ActionBlock
	public var selector: Selector

	public init(_ block: @escaping ActionBlock) {
		self.action = block
		selector = #selector(onCallback(sender:))
	}

	@objc
	public func onCallback(sender: AnyObject) {
		UIWindow.main.endEditing(true)
		action(sender)
	}
}

public extension NSObject {

	var targetSelector: TargetSelector? {
		get {
			return self.getAttr("__target_selector__") as? TargetSelector
		}
		set {
			self.setAttr("__target_selector__", newValue)
		}
	}

}

public extension UIBarButtonItem {
	var onClickBarItem: ActionBlock? {
		get {
			return self.targetSelector?.action
		}
		set {
			if let b = newValue {
				let a = TargetSelector(b)
				self.target = a
				self.action = a.selector
			} else {
				self.targetSelector = nil
			}
		}
	}
}