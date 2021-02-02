//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

//注意弱引用 [weak self]

public typealias ControlEventCallback = (UIControl) -> Void

public class ControlEvent: NSObject {
	public var event: UIControl.Event
	public var block: ControlEventCallback

	public init(_ control: UIControl, _ event: UIControl.Event, _ block: @escaping ControlEventCallback) {
		self.event = event
		self.block = block
		super.init()
		control.addTarget(self, action: #selector(ControlEvent.onEvent(_:)), for: event)
	}

	deinit {
	}

	@objc
	public func onEvent(_ control: UIControl) {
		self.block(control)
	}

}

public extension UIControl {
	func click(_ target: AnyObject, _ action: Selector) {
		self.isUserInteractionEnabled = true
		self.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
	}

	func on(_ event: UIControl.Event, _ block: @escaping ControlEventCallback) {
		self.isUserInteractionEnabled = true
		let c = ControlEvent(self, event, block)
		let key = "_control_event_" + event.rawValue.description
		setAttr(key, c)
	}

	func click(_ block: @escaping ControlEventCallback) {
		on(.touchUpInside, block)
	}

}

fileprivate class FeedbackGestureDelegate: NSObject, UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return true
	}
}

fileprivate let FeedbackDelegate = FeedbackGestureDelegate()

public extension UIView {
	func setupFeedback() {
		if self.feedbackFlag {
			return
		}
		self.feedbackFlag = true
		self.isUserInteractionEnabled = true
		let lr = UILongPressGestureRecognizer(target: self, action: #selector(onGestureFeedback(r:)))
		lr.minimumPressDuration = 0
		lr.cancelsTouchesInView = false
		lr.delegate = FeedbackDelegate
		self.addGestureRecognizer(lr)
	}

	fileprivate var feedbackFlag: Bool {
		get {
			return self.getAttr("__feedbackFlag_") as? Bool ?? false
		}
		set {
			self.setAttr("__feedbackFlag_", newValue)
		}
	}

	@objc
	fileprivate func onGestureFeedback(r: UIGestureRecognizer) {
		switch r.state {
		case .began:
			self.backgroundColorBackup = self.backgroundColor
			self.backgroundColor = self.feedbackBackgroundColor
		case .ended, .cancelled, .failed:
			if let c = self.backgroundColorBackup {
				self.backgroundColor = c
			}
		default:
			break
		}
	}

	var feedbackBackgroundColor: UIColor {
		get {
			return self.getAttr("feedbackBackgroundColor") as? UIColor ?? Color.white(240)
		}
		set {
			self.setAttr("feedbackBackgroundColor", newValue)
		}
	}

	fileprivate var backgroundColorBackup: UIColor? {
		get {
			return self.getAttr("__back_color_back__") as? UIColor
		}
		set {
			self.setAttr("__back_color_back__", newValue)
		}
	}

}

public extension UIView {
	private var clickBlock: ViewClickBlock? {
		get {
			return getAttr("__click__") as? ViewClickBlock
		}
		set {
			setAttr("__click__", newValue)
		}
	}

	@objc
	private func onClickView(r: UITapGestureRecognizer) {
		self.clickBlock?(self)
	}

	func clickView(_ block: @escaping ViewClickBlock) {
		self.clickBlock = block
		addTapPress(self, #selector(onClickView(r:)))
	}

	@discardableResult
	func addLongPress(_ target: AnyObject, _ action: Selector) -> UILongPressGestureRecognizer {
		self.isUserInteractionEnabled = true
		let longPress = UILongPressGestureRecognizer(target: target, action: action)
		self.addGestureRecognizer(longPress)
		return longPress
	}

	@discardableResult
	func addTapPress(_ target: AnyObject, _ action: Selector) -> UITapGestureRecognizer {
		self.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: target, action: action)
		self.addGestureRecognizer(tap)
		return tap
	}

	func hideKeyboardOnTap() {
		addTapPress(hideKeyboardObject, #selector(HideKeyboardObject.hideKeyboardCallback(_:)))
	}
}

private class HideKeyboardObject: NSObject {

	@objc
	func hideKeyboardCallback(_ r: UIGestureRecognizer) {
		UIWindow.main.endEditing(true)
	}
}

private let hideKeyboardObject = HideKeyboardObject()

public extension UILongPressGestureRecognizer {
	var isBegan: Bool {
		return self.state == .began
	}
}