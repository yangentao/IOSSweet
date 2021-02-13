import UIKit
import ObjectiveC
import SwiftSweet
public extension UIScrollView {

	var pullView: PullToRefreshView? {
		for v in self.subviews {
			if v is PullToRefreshView {
				return v as? PullToRefreshView
			}

		}
		return nil

	}

	func addPullRefresh(_ actionHandler: @escaping BlockVoid) {
		if let v = self.pullView {
			v.actionHandler = actionHandler
			return
		}

		isMultipleTouchEnabled = false
		panGestureRecognizer.maximumNumberOfTouches = 1

		let v = PullToRefreshView()
		v.actionHandler = actionHandler
		v.loadingView = PullToRefreshLoadingViewCircle()
		addSubview(v)

		v.observing = true

		v.fillColor = Theme.themeColor
		v.backgroundColor = self.backgroundColor
	}

	func removePullRefresh() {
		pullView?.disassociateDisplayLink()
		pullView?.observing = false
		pullView?.removeFromSuperview()
	}
}

public extension UIView {
	func dg_center(_ usePresentationLayerIfPossible: Bool) -> CGPoint {
		if usePresentationLayerIfPossible, let presentationLayer = layer.presentation() {
			// Position can be used as a center, because anchorPoint is (0.5, 0.5)
			return presentationLayer.position
		}
		return center
	}
}

public extension UIGestureRecognizer.State {
	func isAnyOf(_ values: [UIGestureRecognizer.State]) -> Bool {
		return values.contains(where: { $0 == self })
	}
}
