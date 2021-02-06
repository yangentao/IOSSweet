//
// Created by yangentao on 2019/11/10.
//

import Foundation


public protocol Applyable: class {

}

public extension Applyable {

    func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

public func println(_ items: Any?...) {
    for a in items {
        if let v = a ?? nil {
            print(v, terminator: " ")
        } else {
            print("nil", terminator: " ")
        }
    }
    print("")
}

public func printStr(_ items: Any?...) -> String {
    var buf: String = ""
    for a in items {
        if let b = a ?? nil {
            print(b, terminator: " ", to: &buf)
        } else {
            print("nil", terminator: " ", to: &buf)
        }
    }
    return buf
}

public func buildStr(_ items: Any?...) -> String {
    var buf: String = ""
    for a in items {
        if let b = a ?? nil {
            print(b, terminator: "", to: &buf)
        } else {
            print("nil", terminator: "", to: &buf)
        }
    }
    return buf
}
