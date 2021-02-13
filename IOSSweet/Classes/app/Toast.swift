//
// Created by entaoyang on 2019-02-17.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet

public extension UIViewController {
    var toast: Toast {
        if let t = self.getAttr("__toast__") as? Toast {
            return t
        } else {
            let a = Toast(self)
            self.setAttr("__toast__", a)
            return a
        }
    }
}

public class Toast {
    private weak var page: UIViewController?

    private let labelView = UILabel(frame: Rect.zero)
    private var msgList: [String] = []
    private let DELAY: Double = 4
    private var scheduleItem: ScheduleItem? = nil

    public init(_ c: UIViewController) {
        self.page = c
        labelView.roundLayer(6)
        labelView.backgroundColor = Color.grayF(0.8)
        labelView.align(.center)
        labelView.textColor = Color.white
        labelView.shadow(offset: 6)
    }

    private func next() {
        guard let p = self.page else {
            return
        }
        if labelView.superview != nil {
            return
        }
        if msgList.isEmpty {
            closeMe()
            return
        }
        let text = msgList.remove(at: 0)
        labelView.text = text
        p.view.addSubview(labelView)
        p.view.bringSubviewToFront(labelView)
        let sz = labelView.sizeThatFits(Size.zero)
        labelView.constraints { c in
            c.centerParent()
            c.width.geConst(150)
            c.width.leConst(300)
            c.height.geConst(60)
            c.height.leConst(100)
            c.width.eqConst(sz.width + 30).priority(.defaultHigh)
            c.height.eqConst(sz.height + 24).priority(.defaultHigh)
        }
        labelView.alpha = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.labelView.alpha = 1
        }
        labelView.clickView { [weak self] v in
            self?.closeMe()
        }
        Task.foreDelay(seconds: DELAY) { [weak self] in
            self?.closeMe()
        }
    }

    public func show(_ msg: String) {
        msgList.append(msg)
        next()
    }

    private func closeMe() {
        UIView.animate(withDuration: 0.2, animations: {
            self.labelView.alpha = 0
        }, completion: { [weak self] b in
            self?.labelView.constraintRemoveAll()
            self?.labelView.removeFromSuperview()
            let emp = self?.msgList.isEmpty ?? true
            if !emp {
                self?.next()
            }
        })
    }
}