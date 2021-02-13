//
// Created by entaoyang@163.com on 2017/10/16.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
open class BasePage: UIViewController, MsgListener {

    private(set) public lazy var titleBar: TitleBar = TitleBar(self)

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

//		self.automaticallyAdjustsScrollViewInsets = false
        self.view.backColor(Colors.background)
        MsgCenter.listenAll(self)
    }

    open func onTitleBarAction(sender: UIBarButtonItem, tags: String) {

    }

    open func onSlideBack() {
        self.close(false)
    }

    open func onTitleBarBack() {
        self.close()
    }

    private func makeEdgeGestureFirst() {
        guard let sv = self.view.firstView({
            $0 is UIScrollView
        }) as? UIScrollView else {
            return
        }
        if let gs = self.view!.gestureRecognizers {
            for g in gs {
                if g is UIScreenEdgePanGestureRecognizer {
                    sv.panGestureRecognizer.require(toFail: g)
                    return
                }
            }
        }
    }

    open func hideKeyboardOnClick() {
        self.view.hideKeyboardOnTap()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//		let c = NotificationCenter.default
//		c.addObserver(self, selector: #selector(keyboardWillShow(n:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//		c.addObserver(self, selector: #selector(keyboardWillHide(n:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        makeEdgeGestureFirst()

    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//		let c = NotificationCenter.default
//		c.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//		c.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

//	@objc
//	func keyboardWillShow(n: Notification) {
//		guard  let ed = self.view.findActiveEdit() else {
//			return
//		}
//		let editRect = ed.screenFrame
//		if let kbFrame: CGRect = n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//			let offset: CGFloat = editRect.origin.y + editRect.size.height - kbFrame.origin.y + 10
//			if offset > 0 {
//				let duration = n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
//				UIView.animate(withDuration: duration) {
//					self.view.frame = CGRect(x: 0.0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
//				}
//			}
//		}
//
//	}
//
//	@objc
//	func keyboardWillHide(n: Notification) {
//		let duration: Double = n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
//		UIView.animate(withDuration: duration) {
//			self.view.frame = self.view.bounds
//		}
//	}

    open func onMsg(msg: Msg) {

    }

}
