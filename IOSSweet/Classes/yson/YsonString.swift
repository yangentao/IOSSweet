//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class YsonString: YsonValue, ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral {
	public typealias StringLiteralType = String
	public typealias UnicodeScalarLiteralType = String
	public typealias ExtendedGraphemeClusterLiteralType = String

	public var data: String = ""

	public init(_ s: String) {
		self.data = s
		super.init()
	}

	public required init(stringLiteral value: StringLiteralType) {
		self.data = value
		super.init()
	}

	public required init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self.data = value
		super.init()
	}

	public required init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.data = value
		super.init()
	}

	public override func writeTo(_ buf: inout String) {
		buf.append("\"")
		buf.append(escapeJson(data))
		buf.append("\"")
	}
}