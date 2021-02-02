//
// Created by entaoyang on 2019-01-08.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public var debugModel = true

public typealias EdgeInset = UIEdgeInsets

public extension UIScreen {

	static var width: CGFloat {
		return self.main.bounds.width
	}
	static var height: CGFloat {
		return self.main.bounds.height
	}
}

@dynamicMemberLookup
public class _R {
	public subscript(dynamicMember member: String) -> String {
		return member
	}
}

public let R = _R()

