//
// Created by yangentao on 2019/10/28.
//

import Foundation

extension HttpResp {

	var ysonObject: YsonObject? {
		if let s = self.text {
			return Yson.parseObject(s)
		}
		return nil
	}
}