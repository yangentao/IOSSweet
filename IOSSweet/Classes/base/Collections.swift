//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation

infix operator =*: ComparisonPrecedence
infix operator !=*: ComparisonPrecedence

//IN
@inlinable
public func =*<T: Equatable, C: Sequence>(e: T, c: C) -> Bool where C.Element == T {
	return c.contains(e)
}

//NOT IN
public func !=*<T: Equatable, C: Sequence>(e: T, c: C) -> Bool where C.Element == T {
	return !c.contains(e)
}

public extension ArraySlice {

	var toArray: [Element] {
		return Array<Element>(self)
	}
}

public extension Sequence {
	var toArray: Array<Element> {
		Array<Element>(self)
	}

	func sortedAsc<T>(_ block: (Element) -> T) -> [Element] where T: Comparable {
		self.sorted(by: { block($0) < block($1) })
	}

	func sortedDesc<T>(_ block: (Element) -> T) -> [Element] where T: Comparable {
		self.sorted(by: { block($1) < block($0) })
	}

	func sumBy<T>(_ block: (Element) -> T) -> T where T: Numeric {
		var m: T = 0
		for e in self {
			m += block(e)
		}
		return m
	}
}

public extension Sequence where Element: Hashable {
	var toSet: Set<Element> {
		Set<Element>(self)
	}
}

public extension Sequence where Element: Numeric {
	func sum() -> Element {
		var m: Element = 0
		for a in self {
			m += a
		}
		return m
	}

}

public extension Collection {
	var notEmpty: Bool {
		!self.isEmpty
	}
}

public extension Array {

	func first(_ block: (Element) -> Bool) -> Element? {
		for e in self {
			if block(e) {
				return e
			}
		}
		return nil
	}

	func first(size: Int) -> [Element] {
		var ls = [Element]()

		var n = size
		if n > self.count {
			n = self.count
		}

		for i in 0..<n {
			ls.append(self[i])
		}
		return ls
	}

	//只删除第一个符合条件的, 返回被删除的元素
	mutating func removeFirstIf(block: (Element) -> Bool) -> Element? {
		for i in self.indices {
			let item = self[i]
			if block(item) {
				self.remove(at: i)
				return item
			}
		}
		return nil
	}

	//返回被删除的元素
	@discardableResult
	mutating func removeAllIf(block: (Element) -> Bool) -> [Element] {
		var arr = [Element]()
		var i = 0
		while i < self.count {
			let item = self[i]
			if block(item) {
				self.remove(at: i)
				arr.append(item)
			} else {
				i += 1
			}
		}
		return arr
	}

	static func +=(lhs: inout Array, rhs: Element) {
		lhs.append(rhs)
	}

	mutating func sortAsc<T>(_ block: (Element) -> T) where T: Comparable {
		self.sort(by: { block($0) < block($1) })
	}

	mutating func sortDesc<T>(_ block: (Element) -> T) where T: Comparable {
		self.sort(by: { block($1) < block($0) })
	}

}

public extension Array where Element == Any {

	mutating func addAll<C>(_ c: C) where C: Sequence {
		for a in c {
			self.append(a)
		}
	}

	static func +=<C>(lhs: inout Array<Any>, rhs: C) where C: Sequence {
		lhs.addAll(rhs)
	}

}

public extension Set {
	mutating func clear() {
		self.removeAll(keepingCapacity: true)
	}

}

public extension Set where Element: Hashable {

	mutating func add(_ e: Element) {
		self.insert(e)
	}
}

public extension Dictionary {

	var keySet: Set<Key> {
		return Set<Key>(self.keys)
	}
	var valueArray: [Value] {
		return Array<Value>(self.values)
	}

	//保留set中的元素
	mutating func retain(_ keySet: Set<Key>) {
		var allKeys = Set<Key>(self.keys)
		allKeys.subtract(keySet)
		for k in allKeys {
			self.removeValue(forKey: k)
		}

	}

	//保留set中的元素
	mutating func retain(_ keySet: Array<Key>) {
		var allKeys = Set<Key>(self.keys)
		allKeys.subtract(keySet)
		for k in allKeys {
			self.removeValue(forKey: k)
		}

	}

	mutating func putAll(dic: Dictionary<Key, Value>) {
		for e in dic {
			self[e.key] = e.value
		}
	}

	func transformKey<K>(_ block: (Key) -> K) -> [K: Value] where K: Hashable {
		var m: [K: Value] = [:]
		m.reserveCapacity(self.capacity)
		for (k, v) in self {
			m[block(k)] = v
		}
		return m
	}

	func transformValue<V>(_ block: (Value) -> V) -> [Key: V] {
		var m: [Key: V] = [:]
		m.reserveCapacity(self.capacity)
		for (k, v) in self {
			m[k] = block(v)
		}
		return m
	}

	func transform<K, V>(_ block: (Key, Value) -> (K, V)) -> [K: V] where K: Hashable {
		var m: [K: V] = [:]
		m.reserveCapacity(self.capacity)
		for (k, v) in self {
			let (a, b) = block(k, v)
			m[a] = b
		}
		return m
	}
}

public extension Array where Element: Equatable {
	static func -=(lhs: inout Array, rhs: Element?) {
		if let r = rhs {
			lhs.removeAllIf { e in
				e == r
			}
		}
	}

	@discardableResult
	mutating func addOnAbsence(_ ele: Element) -> Bool {
		if self.contains(ele) {
			return false
		}
		self.append(ele)
		return true
	}
}

public class MySet<Element: Hashable> {
	public var set: Set<Element>

	public init(_ capcity: Int = 16) {
		set = Set<Element>(minimumCapacity: capcity)
	}

	public init<Source>(_ sequence: Source) where Element == Source.Element, Source: Sequence {
		set = Set<Element>(sequence)
	}

	public init(arrayLiteral elements: Element...) {
		set = Set<Element>(minimumCapacity: elements.count + 8)
		for e in elements {
			set.insert(e)
		}
	}
}

public class MyMap<Key: Hashable, Value> {
	public var map: Dictionary<Key, Value>

	public init(_ capcity: Int = 16) {
		map = Dictionary<Key, Value>(minimumCapacity: capcity)
	}

	public init(dictionaryLiteral elements: (Key, Value)...) {
		map = Dictionary<Key, Value>(minimumCapacity: elements.count + 8)
		for (k, v) in elements {
			map[k] = v
		}
	}
}

public class MyArray<Element> {
	public var array: Array<Element>

	public init() {
		array = Array<Element>()
	}

	public init<S>(_ s: S) where Element == S.Element, S: Sequence {
		array = Array<Element>(s)
	}

	public init(repeating repeatedValue: Element, count: Int) {
		array = Array<Element>(repeating: repeatedValue, count: count)
	}
}
