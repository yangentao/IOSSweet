//
// Created by entaoyang on 2019-02-19.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
	static var makePlain: UITableView {
		return UITableView.Plain
	}
	static var Plain: UITableView {
		let t = UITableView(frame: Rect.zero, style: .plain)
		t.tableFooterView = UIView(frame: Rect.zero)
		return t
	}
}