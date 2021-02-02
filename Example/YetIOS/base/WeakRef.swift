//
// Created by entaoyang@163.com on 2019-07-31.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

//init只能是类的实例,
public class WeakRef<T: AnyObject>: Equatable {

	public weak var value: T?

	public init(_ value: T) {
		self.value = value
	}

	public var isNull: Bool {
		return value == nil
	}
	public var notNull: Bool {
		return value != nil
	}

	public static func ==(lhs: WeakRef, rhs: WeakRef) -> Bool {
		return lhs === rhs || lhs.value === rhs.value
	}

}
