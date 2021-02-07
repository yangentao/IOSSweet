//
// Created by entaoyang@163.com on 2017/10/12.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class Yson {
    public static func parse(_ json: String) -> YsonValue? {
        YParser.parseValue(json)
    }

    public static func parseObject(_ json: String) -> YsonObject? {
        YParser.parseObject(json)
    }

    public static func parseArray(_ json: String) -> YsonArray? {
        YParser.parseArray(json)
    }
}

public extension String {
    var toYsonObject: YsonObject? {
        YsonObject(self)
    }
    var toYsonArray: YsonArray? {
        YsonArray(self)
    }
}

public func yson(@AnyBuilder _ block: AnyBuildBlock) -> YsonObject {
    let ls: [KeyAny] = block().itemsTyped(true)
    let yo = YsonObject()
    yo.data.reserveCapacity(ls.count)
    for ka in ls {
        if let v = ka.value ?? nil {
            yo.put(ka.key, v)
        } else {
            yo.putNull(ka.key)
        }
    }
    return yo
}

public func ysonArray(_ items: [Any?]) -> YsonArray {
    let ya = YsonArray()
    ya.data.reserveCapacity(items.count)
    for item in items {
        let v = anyValueToYsonValue(item)
        ya.data.append(v)
    }
    return ya
}

func anyValueToYsonValue(_ value: Any?) -> YsonValue {
    guard let v = value ?? nil else {
        return YsonNull.inst
    }
    switch v {
    case nil:
        return YsonNull.inst
    case is NSNull:
        return YsonNull.inst
    case let yv as YsonValue:
        return yv
    case let s as String:
        return YsonString(s)
    case let s as NSString:
        return YsonString(String(s as NSString))
    case let b as Bool:
        return YsonBool(b)
    case let f as CGFloat:
        return YsonNum(Double(f))
    case let num as NSNumber:
        return YsonNum(num)
    case let data as Data:
        return YsonBlob(data)
    case let data as NSData:
        return YsonBlob(Data(referencing: data as NSData))
    case let pairs as Array<KeyAny>:
        let yo = YsonObject()
        yo.data.reserveCapacity(pairs.count)
        for p in pairs {
            if let pv = p.value ?? nil {
                yo.put(p.key, pv)
            } else {
                yo.putNull(p.key)
            }
        }
        return yo
    case let map as [String: Any]:
        let yo = YsonObject()
        yo.data = dicValueToDicYson(map)
        return yo
    case let ar as Array<Any>:
        let ya = YsonArray()
        ya.data = arrayValueToArrayYson(es: ar)
        return ya

    default:
        let m = Mirror(reflecting: v)
        logd(m.description)
        logd(m.displayStyle)
        logd(m.subjectType)
        dump(v)
        return YsonNull.inst
    }
}

func dicValueToDicYson(_ es: [String: Any]) -> [String: YsonValue] {
    var dic = [String: YsonValue]()
    dic.reserveCapacity(es.count)

    for (k, v) in es {
        let yv = anyValueToYsonValue(v)
        dic[k] = yv
    }
    return dic
}

func arrayValueToArrayYson(es: [Any]) -> [YsonValue] {
    var data = [YsonValue]()
    data.reserveCapacity(es.count)
    for e in es {
        let yv = anyValueToYsonValue(e)
        data.append(yv)
    }
    return data
}


//public protocol JsonValueTypes {
//
//}
//
//extension NSNull: JsonValueTypes {
//}
//
//extension String: JsonValueTypes {
//}
//
//extension NSNumber: JsonValueTypes {
//}
//
//extension Bool: JsonValueTypes {
//}
//
//extension Data: JsonValueTypes {
//}

