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

func anyLiteral2YsonValue(_ v: Any?) -> YsonValue {
	switch v {
	case nil:
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
	case let map as [String: Any]:
		let yo = YsonObject()
		yo.data = dicLiteral2DicYson(map)
		return yo
	case let ar as Array<Any>:
		let ya = YsonArray()
		ya.data = arrayLiteral2ArrayYson(es: ar)
		return ya

	default:
		let m = Mirror(reflecting: v!)
		logd(m.description)
		logd(m.displayStyle)
		logd(m.subjectType)
		dump(v)
		return YsonNull.inst
	}
}

func dicLiteral2DicYson(_ es: [String: Any]) -> [String: YsonValue] {
	var dic = [String: YsonValue]()
	dic.reserveCapacity(es.count)

	for (k, v) in es {
		let yv = anyLiteral2YsonValue(v)
		dic[k] = yv
	}
	return dic
}

func arrayLiteral2ArrayYson(es: [Any]) -> [YsonValue] {
	var data = [YsonValue]()
	data.reserveCapacity(es.count + 8)
	for e in es {
		let yv = anyLiteral2YsonValue(e)
		data.append(yv)
	}
	return data
}

