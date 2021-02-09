//
// Created by entaoyang@163.com on 2019/9/20.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation
import UIKit

public extension URL {
	func open() {
		if #available(iOS 10, *) {
			UIApplication.shared.open(self, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(self)
		}
	}
}

public func UrlOpen(_ s: String) {
	URL(string: s)?.open()
}

public func SmsTo(_ s: String) {
	if s.notEmpty {
		UrlOpen("sms://\(s)")
	}
}

public func TelTo(_ s: String) {
	if s.notEmpty {
		UrlOpen("tel://\(s)")
	}
}