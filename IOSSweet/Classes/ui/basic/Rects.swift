//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias Rect = CGRect


public extension CGRect {
	var center: CGPoint {
		return CGPoint(x: (self.minX + self.maxX) / 2, y: (self.minY + self.maxY) / 2)
	}

	//	static var zero: CGRect {
	//		return CGRect(x: 0, y: 0, width: 0, height: 0)
	//	}
	static var one: CGRect {
		return CGRect(x: 0, y: 0, width: 1, height: 1)
	}

	static func sized(_ sz: CGSize) -> CGRect {
		return sized(sz.width, sz.height)
	}

	static func sized(_ w: CGFloat) -> CGRect {
		return sized(w, w)
	}

	static func sized(_ w: CGFloat, _ h: CGFloat) -> CGRect {
		return CGRect(x: 0, y: 0, width: w, height: h)
	}

	static func make(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
		return CGRect(x: x, y: y, width: w, height: h)
	}
}
