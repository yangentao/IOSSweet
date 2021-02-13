//
// Created by entaoyang on 2018-12-28.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias Color = UIColor

public extension  UIColor {
	static func rgb(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
		return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
	}

	static func rgba(_ r: Int, _ g: Int, _ b: Int, _ a: Int) -> UIColor {
		return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
	}

	static func gray(_ n: Int) -> UIColor {
		return UIColor(white: CGFloat(CGFloat(255 - n) / 255.0), alpha: 1.0)
	}

	static func grayF(_ f: CGFloat) -> UIColor {
		return UIColor(white: 1.0 - f, alpha: 1.0)
	}

	static func white(_ n: Int) -> UIColor {
		return UIColor(white: CGFloat(CGFloat(n) / 255.0), alpha: 1.0)
	}

	static func whiteF(_ f: CGFloat) -> UIColor {
		return UIColor(white: f, alpha: 1.0)
	}
}

public extension Int {

	var rgb: UIColor {
		return Color.rgb((self & 0x0FF0000) >> 16, (self & 0x00FF00) >> 8, (self & 0x0000FF))
	}
	var argb: UIColor {
		return Color.rgba((self & 0x0FF0000) >> 16, (self & 0x00FF00) >> 8, (self & 0x0000FF), (self >> 24) & 0x00FF)
	}
	var toColor: UIColor {
		return self.argb
	}
}
