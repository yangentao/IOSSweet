//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class YsonBool: YsonValue, ExpressibleByBooleanLiteral {
	public typealias BooleanLiteralType = Bool

	public var data: Bool

	public init(_ b: Bool) {
		self.data = b
		super.init()
	}

	public required init(booleanLiteral value: BooleanLiteralType) {
		self.data = value
	}


	public  override func writeTo(_ buf: inout String) {
		buf.append("\(data)")
	}
}