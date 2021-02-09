//
// Created by entaoyang on 2019-02-12.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class ScaleInAnim: NSObject, UIViewControllerAnimatedTransitioning {

	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 1.0
	}

	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard  let toC = transitionContext.viewController(forKey: .to) else {
			return
		}
		let finalFrame = transitionContext.finalFrame(for: toC)
		var r = Rect()
		let wDh = finalFrame.width / finalFrame.height
		r.size.width = 40
		r.size.height = r.size.width / wDh
		r.origin.x = (UIScreen.width - r.size.width) / 2
		r.origin.y = (UIScreen.height - r.size.height) / 2
		toC.view.frame = r

		let containerView = transitionContext.containerView
		containerView.addSubview(toC.view)

		UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
			toC.view.frame = finalFrame
			toC.view.layoutIfNeeded()
		}, completion: { ok in
			transitionContext.completeTransition(true)
		})

	}
}

public class ScaleOutAnim: NSObject, UIViewControllerAnimatedTransitioning {

	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 1
	}

	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard  let toC = transitionContext.viewController(forKey: .from) else {
			return
		}
		let finalFrame = transitionContext.finalFrame(for: toC)
		var r = Rect()
		let wDh = finalFrame.width / finalFrame.height
		r.size.width = 40
		r.size.height = r.size.width / wDh
		r.origin.x = (UIScreen.width - r.size.width) / 2
		r.origin.y = (UIScreen.height - r.size.height) / 2

		let containerView = transitionContext.containerView
		containerView.addSubview(toC.view)

		UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
			toC.view.frame = r
		}, completion: { ok in
			transitionContext.completeTransition(true)
		})

	}
}