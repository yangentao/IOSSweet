//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

//用于encode/decode
public class YsonNum: YsonValue, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {

	public typealias IntegerLiteralType = Int
	public typealias FloatLiteralType = Double

	public var data: NSNumber = 0
	public var hasDot: Bool = false

	public init(_ v: NSNumber) {
		self.data = v
		super.init()
	}

	public required init(integerLiteral value: Int) {
		data = value.num
		super.init()
	}

	public required init(floatLiteral value: Double) {
		data = value.num
		super.init()
	}

	public override func writeTo(_ buf: inout String) {
		buf.append(String(describing: data))
	}

}

public extension YsonNum {
	  convenience init(_ v: Float) {
		self.init(v.num)
	}

	  convenience init(_ v: Double) {
		self.init(v.num)
	}

	  convenience init(_ v: Decimal) {
		self.init(NSDecimalNumber(decimal: v))
	}

	  convenience init(_ v: CGFloat) {
		self.init(v.num)
	}

	  convenience init(_ v: Int) {
		self.init(v.num)
	}

	  convenience init(_ v: UInt) {
		self.init(v.num)
	}

	  convenience init(_ v: Int8) {
		self.init(v.num)
	}

	  convenience init(_ v: UInt8) {
		self.init(v.num)
	}

	  convenience init(_ v: Int16) {
		self.init(v.num)
	}

	  convenience init(_ v: UInt16) {
		self.init(v.num)
	}

	  convenience init(_ v: Int32) {
		self.init(v.num)
	}

	  convenience init(_ v: UInt32) {
		self.init(v.num)
	}

	convenience init(_ v: Int64) {
		self.init(v.num)
	}

	  convenience init(_ v: UInt64) {
		self.init(v.num)
	}

}

