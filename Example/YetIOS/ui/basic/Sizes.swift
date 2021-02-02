//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

public typealias Size = CGSize

public extension CGSize {

	static func sized(_ w: CGFloat) -> CGSize {
		return sized(w, w)
	}

	static func sized(_ w: CGFloat, _ h: CGFloat) -> CGSize {
		return CGSize(width: w, height: h)
	}

	func added(_ w: CGFloat, _ h: CGFloat) -> CGSize {
		return CGSize(width: self.width + w, height: self.height + h)
	}
}