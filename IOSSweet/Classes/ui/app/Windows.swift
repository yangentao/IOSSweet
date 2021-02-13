//
// Created by entaoyang on 2019-02-15.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {

	static var topController: UIViewController? {
		let rc = UIApplication.shared.keyWindowFirst?.rootViewController ?? UIApplication.shared.delegate?.window??.rootViewController
		if rc != nil {
			return topOf(rc!)
		}
		return nil
	}

	private static func topOf(_ c: UIViewController) -> UIViewController {
		var a = c
		while a.presentedViewController != nil {
			a = a.presentedViewController!
		}

		if a is UINavigationController {
			return topOf((a as! UINavigationController).topViewController!)
		}
		if a is UITabBarController {
			return topOf((a as! UITabBarController).selectedViewController!)
		}

		return a
	}

	static func changeRoot(_ newController: UIViewController) {
		if let c = main.rootViewController {
			c.close()
		}
		main.rootViewController = newController
	}

	static var main: UIWindow {
		return UIApplication.shared.keyWindowFirst!
	}

}