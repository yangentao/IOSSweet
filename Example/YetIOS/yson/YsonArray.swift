//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class YsonArray: YsonValue, ExpressibleByArrayLiteral {
	public typealias ArrayLiteralElement = Any
	public var data: [YsonValue] = [YsonValue]()

	public init(_ capcity: Int = 16) {
		if capcity > 4 {
			data.reserveCapacity(capcity)
		}
		super.init()
	}

	public required init(arrayLiteral elements: ArrayLiteralElement...) {
		data = arrayValueToArrayYson(es: elements)
		super.init()
	}

	public convenience init?(_ json: String) {
		guard let a = YParser.parseArray(json) else {
			return nil
		}
		self.init()
		self.data = a.data
	}

	public subscript(index: Int) -> YsonValue {
		get {
			if index < self.data.count {
				return self.data[index]
			}
			return YsonNull.inst
		}
		set {
			if index < self.data.count {
				self.data[index] = newValue
			} else if index == self.data.count {
				self.data.append(newValue)
			}
		}
	}

	public override func writeTo(_ buf: inout String) {
		buf.append("[")
		var first = true
		for v in data {
			if !first {
				buf.append(",")
			}
			buf.append(v.yson)
			first = false
		}
		buf.append("]")
	}
}

extension YsonArray: Sequence {
	public func makeIterator() -> IndexingIterator<[YsonValue]>.Iterator {
		data.makeIterator()
	}
}

public extension YsonArray {

	var count: Int {
		data.count
	}

	func append(_ value: Bool) {
		data.append(YsonBool(value))
	}

	func append(_ value: String) {
		data.append(YsonString(value))
	}

	func appendNull() {
		data.append(YsonNull.inst)
	}

	func append(_ value: YsonValue) {
		data.append(value)
	}

	func add(_ v: YsonValue) {
		data.append(v)
	}

	var firstObject: YsonObject? {
		if !self.data.isEmpty {
			return self[0] as? YsonObject
		}
		return nil
	}

}

public extension YsonArray {

	func append(_ value: UInt64) {
		data.append(YsonNum(value))
	}

	func append(_ value: Int64) {
		data.append(YsonNum(value))
	}

	func append(_ value: Int32) {
		data.append(YsonNum(value))
	}

	func append(_ value: UInt32) {
		data.append(YsonNum(value))
	}

	func append(_ value: Int16) {
		data.append(YsonNum(value))
	}

	func append(_ value: UInt16) {
		data.append(YsonNum(value))
	}

	func append(_ value: Int8) {
		data.append(YsonNum(value))
	}

	func append(_ value: UInt8) {
		data.append(YsonNum(value))
	}

	func append(_ value: Int) {
		data.append(YsonNum(value))
	}

	func append(_ value: UInt) {
		data.append(YsonNum(value))
	}

	func append(_ value: Double) {
		data.append(YsonNum(value))
	}

	func append(_ value: Float) {
		data.append(YsonNum(value))
	}

	func append(_ value: CGFloat) {
		data.append(YsonNum(value))
	}

	func append(_ value: NSNumber) {
		data.append(YsonNum(value))
	}
}

public extension YsonArray {
	var arrayInt: [Int] {
		self.data.map {
			($0 as! YsonNum).data.intValue
		}
	}
	var arrayDouble: [Double] {
		self.data.map {
			($0 as! YsonNum).data.doubleValue
		}
	}
	var arrayString: [String] {
		self.data.map {
			($0 as! YsonString).data
		}
	}
	var arrayObject: [YsonObject] {
		self.data.map {
			$0 as! YsonObject
		}
	}

	func arrayModel<V: Decodable>() -> [V] {
		var ls = [V]()
		for ob in self.arrayObject {
			if let m: V = ob.toModel() {
				ls.append(m)
			}
		}
		return ls
	}

}