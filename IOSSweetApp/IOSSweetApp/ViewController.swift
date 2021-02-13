//
//  ViewController.swift
//  IOSSweetApp
//
//  Created by yangentao on 2021/2/10.
//
//

import UIKit
import SwiftSweet

extension MsgID {
    static let labelTextChanged = MsgID("label.text.changed")
}

class ViewController: UIViewController, MsgListener {
    lazy var label: UILabel = UILabel(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view += label.apply { lb in
            lb.constraints { c in
                c.centerParent()
                c.width(200)
                c.height(80)
            }
            lb.named("label")
            lb.backgroundColor = .green
            lb.text = "Hello"
            lb.textColor = .red
            lb.textAlignment = .center
        }

        label.propChanged("text", fire: .labelTextChanged)
//        for i in 0...5 {
        Task.foreDelay(seconds: Double(0)) {
            self.label.text = "hahahahha \(0)"
        }
//        }
        MsgCenter.listenAll(self)
        label.propChanged("text", target: self, selector: #selector(Self.onTextChanged))
        label.propChangedInfo("text", target: self, selector: #selector(Self.onTextChangedInfo(_:)))

    }

    @objc
    func onTextChanged() {
        logd("onTextChanged: ")
    }

    @objc
    func onTextChangedInfo(_ info: PropChangedInfo) {
        logd("onTextChanged: ", info.keyPath, info.oldValue, info.newValue, info.obj)
    }

    func onMsg(msg: Msg) {
        logd("onMsg: ", msg.msg, msg["oldValue"], msg["newValue"], msg.sender)
    }


}
