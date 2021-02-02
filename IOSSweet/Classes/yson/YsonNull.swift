//
// Created by entaoyang@163.com on 2017/10/29.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class YsonNull: YsonValue, ExpressibleByNilLiteral {

	public static var inst: YsonNull = YsonNull()

	public override init() {
		super.init()
	}

	public required init(nilLiteral: ()) {
	}


	public override func writeTo(_ buf: inout String) {
		buf.append("null")
	}
}

