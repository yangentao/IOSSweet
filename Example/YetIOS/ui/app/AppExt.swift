//
// Created by entaoyang@163.com on 2017/10/11.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias App = UIApplication

public extension UIApplication {
	static var statusBarHeight: CGFloat {
		if UIApplication.shared.isStatusBarHidden {
			return 0
		} else {
			return UIApplication.shared.statusBarFrame.height
		}
	}

	static var appDelegate: UIApplicationDelegate {
		return UIApplication.shared.delegate!
	}


	static var versionName: String? {
		return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
	}
	static var versionCode: Int {
		let a = Bundle.main.infoDictionary?["CFBundleVersion"]
		if let s = a as? String {
			return Int(s) ?? 0
		}
		return 0
	}

	static var sysIdent: String {
		return UIDevice.current.identifierForVendor?.description ?? ""
	}
	static var sysVersion: String {
		return UIDevice.current.systemVersion
	}
	static var sysModel: String {
		return UIDevice.current.model
	}
}