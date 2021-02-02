//
// Created by entaoyang@163.com on 2017/10/10.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation

public extension NSObjectProtocol {

    @discardableResult
    func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

public protocol IObject: class {

}

extension IObject {
    @discardableResult
    func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

private var attr_key = "_attrkey_"

private class MapWrap {
    var map = [String: Any]()
}

public extension NSObject {

    private var _attrMap: MapWrap {
        if let m = objc_getAssociatedObject(self, &attr_key) as? MapWrap {
            return m
        } else {
            let map = MapWrap()
            objc_setAssociatedObject(self, &attr_key, map, .OBJC_ASSOCIATION_RETAIN)
            return map
        }
    }

    func setAttr(_ key: String, _ value: Any?) {
        if let v = value {
            self._attrMap.map[key] = v
        } else {
            self._attrMap.map.removeValue(forKey: key)
        }
    }

    func getAttr(_ key: String) -> Any? {
        return _attrMap.map[key]
    }

    var tagS: String {
        get {
            return (getAttr("_tagS_") as? String) ?? ""
        }
        set {
            setAttr("_tagS_", newValue)
        }
    }
}


extension NSObject {
    func watch(name: Notification.Name, object: Any?, selector: Selector) {
        self.watch(name: name, object: object, selector: selector, target: self)
    }

    func watch(name: Notification.Name, object: Any?, selector: Selector, target: Any) {
        NotificationCenter.default.addObserver(target, selector: selector, name: name, object: object)
    }

    func watchRemove(name: Notification.Name, object: Any?) {
        self.watchRemove(name: name, object: object, target: self)
    }

    func watchRemove(name: Notification.Name, object: Any?, target: Any) {
        NotificationCenter.default.removeObserver(target, name: name, object: object)
    }

    func notify(name: Notification.Name) {
        self.notify(name: name, object: self)
    }

    func notify(name: Notification.Name, object: Any?) {
        NotificationCenter.default.post(name: name, object: object)
    }

    func notify(name: Notification.Name, userInfo: [AnyHashable: Any]) {
        self.notify(name: name, object: self, userInfo: userInfo)
    }

    func notify(name: Notification.Name, object: Any?, userInfo: [AnyHashable: Any]) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}