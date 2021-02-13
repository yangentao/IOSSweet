//
// Created by entaoyang on 2019-03-11.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
open class MyTabBarPage: UITabBarController, UITabBarControllerDelegate, MsgListener {

	public var onSelectPage: (UIViewController) -> Void = { _ in
	}
	public var onMsgCallback: (MyTabBarPage, Msg) -> Void = { _, _ in
	}
	public var onLoad: (MyTabBarPage) -> Void = { _ in
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
		MsgCenter.listenAll(self)
		self.onLoad(self)
	}

	open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		viewController.tabBarItem.badgeValue = nil
		self.onSelectPage(viewController)
	}

	open func onMsg(msg: Msg) {
		self.onMsgCallback(self, msg)
	}

	public static func make(_ cs: [UIViewController]) -> MyTabBarPage {
		return TabPage(cs)
	}
}

public func TabPage(_ cs: [UIViewController]) -> MyTabBarPage {
	let c = MyTabBarPage()
	c.definesPresentationContext = true
	c.setViewControllers(cs, animated: false)
	if cs.count > 0 {
		c.selectedIndex = 0
	}
	return c
}
