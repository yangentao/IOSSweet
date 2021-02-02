//
// Created by entaoyang@163.com on 2017/10/25.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation

public class MyError: Error, CustomStringConvertible {
	public let msg: String
	public var baseError: Error? = nil

	public init(_ msg: String, _ base: Error? = nil) {
		self.msg = msg
		self.baseError = base
	}

	public var description: String {
		get {
			return "Error: \(msg)"
		}
	}
}

public func throwIf(_ cond: Bool, _ msg: String) throws {
	if (cond) {
		throw MyError(msg)
	}
}

public func fatalIf(_ cond: Bool, _ msg: String) {
	if cond {
		fatalError(msg)
	}
}

public func fataIfDebug(_ msg: String = "") {
	if isDebug {
		fatalError(msg)
	}
}

public func debugFatal(_ msg: String = "Fatal Error!") {
	if isDebug {
		fatalError(msg)
	}
}
