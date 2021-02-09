//
// Created by entaoyang on 2019-03-01.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public func NavPage(_ c: UIViewController) -> MyNavPage {
	return MyNavPage(rootViewController: c)
}

open class MyNavPage: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.interactivePopGestureRecognizer?.delegate = self
	}

	open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if self.viewControllers.count > 0 {
			self.interactivePopGestureRecognizer?.isEnabled = true
			viewController.hidesBottomBarWhenPushed = true
		}
		super.pushViewController(viewController, animated: animated)
	}

	open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		if navigationController.viewControllers.count == 1 {
			self.interactivePopGestureRecognizer?.isEnabled = false
		}
	}

}