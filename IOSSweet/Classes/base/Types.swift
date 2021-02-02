//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation


public typealias BytePointer = UnsafeMutablePointer<Byte>
public typealias ConstBytePointer = UnsafePointer<Byte>
public typealias CharPointer = UnsafeMutablePointer<Int8>
public typealias ConstCharPointer = UnsafePointer<Int8>
public typealias BlockVoid = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias StringBlock = (String) -> Void
public typealias IntBlock = (Int) -> Void
public typealias DoubleBlock = (Double) -> Void


//public func byteArray2CharPtr(data: [UInt8]) -> UnsafeMutablePointer<Int8> {
//    var pt:UnsafeRawBufferPointer
//    data.withUnsafeBytes(<#T##body: (UnsafeRawBufferPointer) throws -> R##(UnsafeRawBufferPointer) throws -> R#>)
//    UnsafeMutableRawPointer(mutating: data).bindMemory(to: Int8.self, capacity: data.count)
//}
//
//public func charArray2BytePtr(data: [Int8]) -> UnsafeMutablePointer<UInt8> {
//	UnsafeMutableRawPointer(mutating: data).bindMemory(to: UInt8.self, capacity: data.count)
//}
//
//func memCount<A, B>(from: A.Type, to: B.Type) -> UInt32 {
//	UInt32(MemoryLayout<A>.stride / MemoryLayout<B>.stride)
//}
//
//func bindStruct<S, T>(p: inout S, newType: T.Type) -> UnsafeMutablePointer<T> {
//	let n = MemoryLayout<S>.stride / MemoryLayout<T>.stride
//	return UnsafeMutableRawPointer(mutating: &p).bindMemory(to: newType, capacity: n)
//}
//
//func bindMem<T>(p: UnsafeRawPointer, newType: T.Type, capacity: Int) -> UnsafeMutablePointer<T> {
//	UnsafeMutableRawPointer(mutating: p).bindMemory(to: newType, capacity: capacity)
//}
