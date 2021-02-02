//
// Created by entaoyang@163.com on 2017/10/11.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

public extension UIViewController {
	func openSafariUrl(_ url: String) {
		if let u = URL(string: url) {
			let v = SFSafariViewController(url: u)
			self.present(v, animated: true)
		}
	}

	var tabItemText: String {
		return self.tabBarItem.title ?? "tabTitle"
	}

	func tabItem(title: String, image: String) {
		let item = self.tabBarItem
		item?.title = title
		item?.image = UIImage(named: image)
	}

	//后缀 "-light"
	func tabItem2(title: String, image: String) {
		let item = self.tabBarItem
		item?.title = title
		item?.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
		item?.selectedImage = UIImage(named: image + Theme.imagePostfix)?.withRenderingMode(.alwaysOriginal)
	}

	func close(_ anim: Bool = true) {
		if let nv = self.navigationController {
			if nil == nv.popViewController(animated: anim) {
				nv.dismiss(animated: anim)
			}
		} else {
			self.dismiss(animated: anim)
		}
	}

	func present(_ page: UIViewController) {
		self.present(page, animated: true)
	}

	func pushPage(_ page: UIViewController, _ animated: Bool = true) {
		if page is UINavigationController {
			self.present(page, animated: animated, completion: nil)
			return
		}
		if self is UINavigationController {
			let c = self as! UINavigationController
			c.pushViewController(page, animated: animated)
			return
		}

		if let nv = self.navigationController {
			nv.pushViewController(page, animated: animated)
			return
		}
		self.present(page, animated: animated, completion: nil)
	}

	func showIndicator(_ color: UIColor = Theme.themeColor) {
		var iv: UIActivityIndicatorView? = nil
		for v in self.view.subviews {
			if let b: UIActivityIndicatorView = v as? UIActivityIndicatorView {
				if v.tag == 998 {
					iv = b
					break
				}
			}
		}
		if iv == nil {
			let v = UIActivityIndicatorView(style: .whiteLarge)
			v.tag = 998
			v.hidesWhenStopped = true
			v.backgroundColor = UIColor.clear
			self.view.addSubview(v)
			v.center = self.view.center
			iv = v
		}
		let v = iv!
		v.color = color
		self.view.bringSubviewToFront(v)
		v.isHidden = false
		v.startAnimating()
	}

	func hideIndicator() {
		for v in self.view.subviews {
			if v is UIActivityIndicatorView && v.tag == 998 {
				let iv = v as! UIActivityIndicatorView
				iv.stopAnimating()
				return
			}
		}
	}
}

public extension UIViewController {

	var tabBarHeight: CGFloat {
		if let c = self.tabBarController {
			return c.tabBar.isHidden ? 0 : c.tabBar.frame.height
		}
		return 0
	}

	func hideKeyboard() {
		self.view.endEditing(true)
	}

}

func makeTabBarController(_ items: [(vc: UIViewController, title: String, gray: String, light: String)]) -> UITabBarController {
	let tabC = UITabBarController()

	var arr = [UINavigationController]()
	for item in items {
		let p = UINavigationController(rootViewController: item.vc)
		let imagA = UIImage.tabBarNamed(item.gray)
		let imagB = UIImage.tabBarNamed(item.light)
		p.tabBarItem = UITabBarItem(title: item.title, image: imagA, selectedImage: imagB)
		arr.append(p)
	}

	tabC.viewControllers = arr
	return tabC
}
