//
// Created by yangentao on 2021/2/6.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation


public class KeyAny: CustomStringConvertible {
    public var key: String = ""
    public var value: Any?

    public init(_ k: String, _ v: Any?) {
        self.key = k
        if let value = v ?? nil {
            self.value = value
        } else {
            self.value = nil
        }
    }

    public var strValue: String? {
        if let v = value ?? nil {
            return "\(v)"
        }
        return nil
    }
    public var intValue: Int {
        return value as! Int
    }
    public var longValue: Long {
        return value as! Long
    }
    public var doubleValue: Double {
        return value as! Double
    }
    public var floatValue: Float {
        return value as! Float
    }
    public var boolValue: Bool {
        return value as! Bool
    }

    public var description: String {
        if let v = value ?? nil {
            return "KeyAny(\(key) = \(v) )"
        }
        return "KeyAny(\(key) = nil )"
    }
}

func testKeyAny() {
    let b = "user" >> {
        "name" >> "Entao"
        "age" >> 99
        "some" >> [1, 2, 3]
        "children" >> {
            "person" >> {
                "name" >> "SUO"
                "age" >> 9
            }
        }
        "address" >> nil
    }
    logd(b)
    let c = "user" >> {
        "name" >> "SUO"
        "age" >> 99
        "children2" >> ["a", 9, nil,
                        "d" >> {
                            "addr" >> "JiNan"
                        }
        ]
        "hello" >> ["a": 1, "b": 2]

    }
    logd(c)
}

public protocol JsonValueTypes {

}

extension NSNull: JsonValueTypes {
}

extension String: JsonValueTypes {
}

extension NSNumber: JsonValueTypes {
}

extension Bool: JsonValueTypes {
}

extension Data: JsonValueTypes {
}

//array 会不同类型混排, 且 element可能是nil
//extension Array: JsonValueTypes where Element: JsonValueTypes {
//}

//map , value maybe nil , value也可能是不同类型
//extension Dictionary: JsonValueTypes where Key == String, Value: JsonValueTypes {
//}


public func >>(k: String, v: NSNull?) -> KeyAny {
    return KeyAny(k, nil)
}

//allow nil
public func >>(k: String, v: String) -> KeyAny {
    return KeyAny(k, v)
}

public func >>(k: String, v: NSNumber) -> KeyAny {
    return KeyAny(k, v)
}

public func >>(k: String, v: Bool) -> KeyAny {
    return KeyAny(k, v)
}

public func >>(k: String, v: Data) -> KeyAny {
    return KeyAny(k, v)
}

public func >>(k: String, v: Array<Any?>) -> KeyAny {
    return KeyAny(k, v)
}

public func >>(k: String, v: Dictionary<String, Any?>) -> KeyAny {
    return KeyAny(k, v)
}

public func >>(k: String, @AnyBuilder _ block: AnyBuildBlock) -> KeyAny {
    let ls: [KeyAny] = block().itemsTyped(true)
    var map = [String: Any](minimumCapacity: ls.count)
    for ka in ls {
        if let v = ka.value ?? nil {
            map[ka.key] = v
        }
    }
    return KeyAny(k, map)
}

