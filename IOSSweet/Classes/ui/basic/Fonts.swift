//
// Created by entaoyang on 2018-12-28.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias Font = UIFont

public extension Font {
	  static func sys(_ size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size)
	}
}

public class Fonts {

	public static var title: Font = semibold(18)
	public static var heading1: Font = semibold(20)
	public static var heading2: Font = medium(17)
	public static var body: Font = regular(13)
	public static var caption: Font = semibold(14)
	public static var tiny: Font = regular(12)

	public static func thin(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.thin)
	}

	public static func light(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.light)
	}

	public static func regular(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.regular)
	}

	public static func medium(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.medium)
	}

	public static func semibold(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
	}

	public static func bold(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.bold)
	}

	public static func heavy(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
	}

	public static func black(_ size: CGFloat) -> Font {
		return Font.systemFont(ofSize: size, weight: UIFont.Weight.black)
	}

}