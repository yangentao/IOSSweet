//
// Created by entaoyang@163.com on 2019-08-09.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import Foundation
import UIKit

let KB = 1024
let MB = 1024 * 1024
let GB = 1024 * 1024 * 1024

public typealias Byte = UInt8
public typealias Long = Int64
public typealias ULong = UInt64


@propertyWrapper
public struct GreatEQ<T: SignedNumeric & Comparable> {
    let minValue: T
    var value: T

    public init(wrappedValue: T, minValue: T) {
        self.minValue = minValue
        self.value = wrappedValue
    }

    public var wrappedValue: T {
        get {
            if value < minValue {
                return minValue
            }
            return value
        }
        set {
            value = newValue
        }
    }
}



public func /(lhs: CGFloat, rhs: Int) -> CGFloat {
    lhs / CGFloat(rhs)
}

public func *(lhs: CGFloat, rhs: Int) -> CGFloat {
    lhs * CGFloat(rhs)
}

extension BinaryInteger {
    var toString: String {
        "\(self)"
    }

    var cint: Int32 {
        Int32(self)
    }
    var int32Value: Int32 {
        Int32(self)
    }
    var uint32Value: UInt32 {
        UInt32(self)
    }
    var intValue: Int {
        Int(self)
    }
    var uintValue: UInt {
        UInt(self)
    }
    var longValue: Long {
        Long(self)
    }
    var ulongValue: ULong {
        ULong(self)
    }
    var floatValue: Float {
        Float(self)
    }
    var doubleValue: Double {
        Double(self)
    }
    var cgfloatValue: CGFloat {
        CGFloat(self)
    }
}

public extension BinaryFloatingPoint {
    var toString: String {
        "\(self)"
    }

    var cint: Int32 {
        Int32(self)
    }
    var int32Value: Int32 {
        Int32(self)
    }
    var uint32Value: UInt32 {
        UInt32(self)
    }
    var intValue: Int {
        Int(self)
    }
    var uintValue: UInt {
        UInt(self)
    }
    var longValue: Long {
        Long(self)
    }
    var ulongValue: ULong {
        ULong(self)
    }
    var floatValue: Float {
        Float(self)
    }
    var doubleValue: Double {
        Double(self)
    }
    var cgfloatValue: CGFloat {
        CGFloat(self)
    }
}

public extension Int8 {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var s: String {
        "\(self)"
    }
    var f: CGFloat {
        CGFloat(self)
    }
}

public extension Int64 {
    var num: NSNumber {
        NSNumber(value: self)
    }

    var date: Date {
        Date(timeIntervalSince1970: Double(self / 1000))
    }
}

public extension UInt32 {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var s: String {
        "\(self)"
    }

    var f: CGFloat {
        CGFloat(self)
    }

}

public extension Float {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var s: String {
        "\(self)"
    }
}

public extension Double {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var s: String {
        "\(self)"
    }
    var f: CGFloat {
        CGFloat(self)
    }

    func keepDot(_ n: Int) -> String {
        String(format: "%.\(n)f", arguments: [self])
    }

    var afterSeconds: DispatchTime {
        DispatchTime.now() + self
    }

    func format(_ block: (NumberFormatter) -> Void) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        block(f)
        return f.string(from: NSNumber(value: self)) ?? ""
    }

}

public extension CGFloat {

    var num: NSNumber {
        NSNumber(value: Double(self))
    }
    var s: String {
        "\(self)"
    }

}

public extension NSNumber {
    var isInteger: Bool {
        !stringValue.contains(".")
    }
}

public extension Int16 {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var f: CGFloat {
        CGFloat(self)
    }
    var s: String {
        "\(self)"
    }
}

public extension Int32 {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var f: CGFloat {
        CGFloat(self)
    }
    var s: String {
        "\(self)"
    }

}

public extension Int {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var f: CGFloat {
        CGFloat(self)
    }
    var s: String {
        "\(self)"
    }

}

public extension UInt {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var f: CGFloat {
        CGFloat(self)
    }
    var s: String {
        "\(self)"
    }
}

public extension UInt8 {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var f: CGFloat {
        CGFloat(self)
    }
    var s: String {
        "\(self)"
    }

}

public extension UInt16 {
    var num: NSNumber {
        NSNumber(value: self)
    }
    var f: CGFloat {
        CGFloat(self)
    }
    var s: String {
        "\(self)"
    }
}

public extension UInt64 {
    var num: NSNumber {
        NSNumber(value: self)
    }
}





