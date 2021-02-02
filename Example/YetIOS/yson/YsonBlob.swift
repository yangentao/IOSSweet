//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

//用于encode/decode
public class YsonBlob: YsonValue {
	public var data: Data

	public init(_ data: Data) {
		self.data = data
		super.init()
	}

	public override func writeTo(_ buf: inout String) {
		let s = data.base64EncodedString()
		buf.append("\"")
		buf.append(escapeJson(s))
		buf.append("\"")
	}
}