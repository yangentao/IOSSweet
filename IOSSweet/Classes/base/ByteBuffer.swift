//
// Created by entaoyang@163.com on 2019-08-10.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation

public class ByteBuffer {
	private(set) public var capacity: Int
	private(set) public var bytes: BytePointer

	public init(capacity: Int) {
		self.capacity = capacity
		bytes = BytePointer.allocate(capacity: capacity)
		bytes.initialize(to: 0)
	}

	public subscript(i: Int) -> Byte {
		get {
			return self.bytes[i]
		}
		set {
			self.bytes[i] = newValue
		}
	}

	public var asChars: UnsafeMutablePointer<Int8> {
		return UnsafeMutableRawPointer(self.bytes).bindMemory(to: Int8.self, capacity: self.capacity)
	}

	deinit {
		self.bytes.deallocate()
	}

	public func dump() {
		for i in 0..<self.capacity {
			print(self.bytes[i])
		}
	}
}

public class CharBuffer {
	private(set) public var capacity: Int
	private(set) public var chars: CharPointer

	public init(capacity: Int) {
		self.capacity = capacity
		chars = CharPointer.allocate(capacity: capacity)
		chars.initialize(to: 0)
	}

	public subscript(i: Int) -> CChar {
		get {
			return self.chars[i]
		}
		set {
			self.chars[i] = newValue
		}
	}

	public var asBytes: UnsafeMutablePointer<UInt8> {
		return UnsafeMutableRawPointer(self.chars).bindMemory(to: UInt8.self, capacity: self.capacity)
	}

	deinit {
		self.chars.deallocate()
	}

	public func dump() {
		for i in 0..<self.capacity {
			print(self.chars[i])
		}
	}
}