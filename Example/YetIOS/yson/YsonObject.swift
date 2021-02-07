//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

@dynamicMemberLookup
public class YsonObject: YsonValue, ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = Any?

    public var data: [String: YsonValue] = [String: YsonValue]()

    public init(_ capcity: Int = 16) {
        if capcity > 4 {
            data.reserveCapacity(capcity)
        }
        super.init()
    }

    public required init(dictionaryLiteral elements: (Key, Value)...) {
        let d = [String: Any?](uniqueKeysWithValues: elements)
        self.data = dicValueToDicYson(d)
        super.init()
    }

    public convenience init?(_ json: String) {
        guard let a = YParser.parseObject(json) else {
            return nil
        }
        self.init(16)
        self.data = a.data
    }

    public subscript(key: String) -> YsonValue {
        get {
            self.data[key] ?? YsonNull.inst
        }
        set {
            self.data[key] = newValue
        }
    }

    public subscript(dynamicMember member: String) -> String? {
        get {
            (data[member] as? YsonString)?.data
        }
        set {
            if let v = newValue {
                data[member] = YsonString(v)
            } else {
                data[member] = YsonNull.inst
            }
        }
    }
    public subscript(dynamicMember member: String) -> Int? {
        get {
            if let v = (data[member] as? YsonNum)?.data {
                return v.intValue
            }
            return nil
        }
        set {
            if let v = newValue {
                data[member] = YsonNum(v)
            } else {
                data[member] = YsonNull.inst
            }
        }
    }
    public subscript(dynamicMember member: String) -> Double? {
        get {
            (data[member] as? YsonNum)?.data.doubleValue

        }
        set {
            if let v = newValue {
                data[member] = YsonNum(v)
            } else {
                data[member] = YsonNull.inst
            }
        }
    }

    public override func writeTo(_ buf: inout String) {
        buf.append("{")
        var first = true
        for (k, v) in data {
            if !first {
                buf.append(",")
            }
            buf.append("\"")
            buf.append(escapeJson(k))
            buf.append("\"")
            buf.append(":")
            buf.append(v.yson)
            first = false
        }
        buf.append("}")
    }

    public var keys: [String] {
        Array<String>(self.data.keys)
    }

    public func has(_ key: String) -> Bool {
        self.data[key] != nil
    }

    public func put(_ key: String, _ value: Any?) {
        data[key] = anyValueToYsonValue(value)
    }

    public func putNull(_ key: String) {
        put(key, YsonNull.inst)
    }

    public func bool(_ key: String) -> Bool? {
        let a = data[key]
        switch a {
        case let yb as YsonBool:
            return yb.data
        case let yn as YsonNum:
            return yn.data.intValue == 1
        default:
            return nil
        }
    }

    public func int(_ key: String) -> Int? {
        let a = data[key]
        switch a {
        case let n as YsonNum:
            return n.data.intValue
        default:
            return nil
        }
    }

    public func double(_ key: String) -> Double? {
        let a = data[key]
        switch a {
        case let n as YsonNum:
            return n.data.doubleValue
        default:
            return nil
        }
    }

    public func str(_ key: String) -> String? {
        let a = data[key]
        switch a {
        case let s as YsonString:
            return s.data
        case let n as YsonNum:
            return n.data.description
        default:
            return nil
        }
    }

    public func obj(_ key: String) -> YsonObject? {
        let a = data[key]
        if let b = a as? YsonObject {
            return b
        }
        return nil
    }

    public func array(_ key: String) -> YsonArray? {
        let a = data[key]
        if let b = a as? YsonArray {
            return b
        }
        return nil
    }
}

extension YsonObject: Sequence {
    public func makeIterator() -> DictionaryIterator<String, YsonValue> {
        data.makeIterator()
    }
}



