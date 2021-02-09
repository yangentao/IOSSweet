//
// Created by entaoyang@163.com on 2017/10/14.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet

public class WatchCenter {
    private class PropItem {
        weak var obj: NSObject?
        let keyPath: String
        weak var actionTarget: AnyObject? = nil
        var action: Selector? = nil
        var msg: MsgID? = nil

        init(obj: NSObject, keyPath: String) {
            self.obj = obj
            self.keyPath = keyPath
        }

        convenience init(obj: NSObject, keyPath: String, actionTarget: AnyObject, action: Selector) {
            self.init(obj: obj, keyPath: keyPath)
            self.actionTarget = actionTarget
            self.action = action
        }

        convenience init(obj: NSObject, keyPath: String, msg: MsgID) {
            self.init(obj: obj, keyPath: keyPath)
            self.msg = msg
        }
    }

    private class _Stub: NSObject {

        private var items: [PropItem] = []

        func listen(obj: NSObject, keyPath: String, actionTarget: AnyObject, action: Selector) {
            let item = PropItem(obj: obj, keyPath: keyPath, actionTarget: actionTarget, action: action)
            items.append(item)
            obj.addObserver(self, forKeyPath: keyPath, context: nil)

            clean()
        }

        func listen(obj: NSObject, keyPath: String, msg: MsgID) {
            let item = PropItem(obj: obj, keyPath: keyPath, msg: msg)
            items.append(item)
            obj.addObserver(self, forKeyPath: keyPath, context: nil)
            clean()
        }

        func remove(obj: NSObject, keyPath: String) {
            _ = items.removeFirstIf {
                $0.obj === obj && $0.keyPath == keyPath
            }
            clean()
        }

        func clean() {
            items.removeAllIf {
                $0.obj == nil || ($0.msg == nil && $0.actionTarget == nil)
            }
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            guard let obj = object as? NSObject, let kp = keyPath else {
                return
            }

            if let a = items.first({ $0.obj === obj && $0.keyPath == kp }) {
                if let msg = a.msg {
                    msg.fire()
                }
                if let t = a.actionTarget, let ac = a.action {
                    _ = t.perform(ac)
                }
            }

        }
    }

    private static let inst = _Stub()

    public static func listen(obj: NSObject, keyPath: String, actionTarget: AnyObject, action: Selector) {
        inst.listen(obj: obj, keyPath: keyPath, actionTarget: actionTarget, action: action)
    }

    public static func listen(obj: NSObject, keyPath: String, msg: MsgID) {
        inst.listen(obj: obj, keyPath: keyPath, msg: msg)
    }

    public static func remove(obj: NSObject, keyPath: String) {
        inst.remove(obj: obj, keyPath: keyPath)
    }
}