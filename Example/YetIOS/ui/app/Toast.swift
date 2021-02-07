//
// Created by entaoyang on 2019-02-17.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
	var toast: Toast {
		if let t = self.getAttr("__toast__") as? Toast {
			return t
		} else {
			let a = Toast(self)
			self.setAttr("__toast__", a)
			return a
		}
	}
}

public class Toast {
	private weak var page: UIViewController?

	private let lb = UILabel(frame: Rect.zero)
	private var msgList = [String]()
	private let DELAY: Double = 4
	private var scheduleItem: ScheduleItem? = nil

	public init(_ c: UIViewController) {
		self.page = c
	}

	public func show(_ msg: String) {
		guard  let p = self.page else {
			return
		}
		if lb.superview != nil {
			if lb.superview === p.view {
				msgList.append(msg)
				return
			} else {
				lb.removeFromSuperview()
			}
		}
		lb.alpha = 0
		p.view.addSubview(lb)
		p.view.bringSubviewToFront(lb)

		lb.roundLayer(4)
		lb.backgroundColor = Color.grayF(0.8)
		lb.align(.center)
		lb.textColor = Color.white
		lb.shadow(offset: 6)

		lb.text = msg

		let sz = lb.sizeThatFits(Size.zero)
		let L = lb.layout
		L.centerParent()
		L.width.ge(150).active()
		L.height.ge(60).active()
		L.width.le(300).active()
		L.height.le(100).active()
		L.width.eq(sz.width + 30).priorityHigh.active()
		L.height.eq(sz.height + 24).priorityHigh.active()

		UIView.animate(withDuration: 0.2) { [weak self] in
			self?.lb.alpha = 1
		}
		lb.clickView { [weak self] v in
			self?.closeView()
		}

		scheduleItem = Task.foreSchedule(DELAY) { [weak self] in
			self?.closeView()
		}
	}

	private func closeView() {
		scheduleItem?.cancel()
		if msgList.isEmpty {
			if lb.superview != nil {
				UIView.animate(withDuration: 0.2, animations: {
					self.lb.alpha = 0
				}, completion: { b in
					self.lb.constraintRemoveAll()
					self.lb.removeFromSuperview()
				})
			}
			return
		}
		let s = msgList.removeFirst()
		lb.text = s
		let sz = lb.sizeThatFits(Size.zero)
		let L = lb.layout
		L.width.eq(sz.width + 30).update()
		L.height.eq(sz.height + 24).update()
		scheduleItem = Task.foreSchedule(DELAY) { [weak self] in
			self?.closeView()
		}
	}

}