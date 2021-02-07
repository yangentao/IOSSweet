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

public extension HttpReq {
    @discardableResult
    static func +=(lhs: HttpReq, rhs: KeyAny) -> HttpReq {
        if let v = rhs.value ?? nil {
            lhs.arg(key: rhs.key, value: "\(v)")
        }
        return lhs
    }
}

public extension HttpPostRaw {
    func bodyJson(@AnyBuilder _ block: AnyBuildBlock) -> Self {
        let yo = yson(block)
        bodyJson(data: yo.yson.data(using: .utf8)!)
        return self
    }
}