//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class YsonValue {
	public func writeTo(_ buf: inout String) {
		fatalError()
	}

	public final var yson: String {
		var text = ""
		text.reserveCapacity(512)
		writeTo(&text)
		return text
	}
}

extension YsonValue: Equatable {

	public static func ==(lhs: YsonValue, rhs: YsonValue) -> Bool {
		if lhs === rhs {
			return true
		}
		if type(of: lhs) != type(of: rhs) {
			return false
		}
		switch lhs {
		case is YsonNull:
			return rhs is YsonNull
		case is YsonNum:
			return rhs is YsonNum && (rhs as! YsonNum).data == (lhs as! YsonNum).data
		case is YsonString:
			return rhs is YsonString && (rhs as! YsonString).data == (lhs as! YsonString).data
		case is YsonBlob:
			return rhs is YsonBlob && (rhs as! YsonBlob).data == (lhs as! YsonBlob).data
		case is YsonArray:
			return rhs is YsonArray && (rhs as! YsonArray).data == (lhs as! YsonArray).data
		case is YsonObject:
			return rhs is YsonObject && (rhs as! YsonObject).data == (lhs as! YsonObject).data
		default:
			return false
		}
	}

}

extension YsonValue: CustomStringConvertible {
	public var description: String {
		self.yson
	}
}

