import UIKit

// MARK: -
// MARK: (CGFloat) Extension

public extension CGFloat {

	func toRadians() -> CGFloat {
		return (self * CGFloat(Double.pi)) / 180.0
	}

	func toDegrees() -> CGFloat {
		return self * 180.0 / CGFloat(Double.pi)
	}

}

// MARK: -
// MARK: DGElasticPullToRefreshLoadingViewCircle

open class PullToRefreshLoadingViewCircle: PullToRefreshLoadingView {

	// MARK: -
	// MARK: Vars

	fileprivate let kRotationAnimation = "kRotationAnimation"

	fileprivate let shapeLayer = CAShapeLayer()
	fileprivate lazy var identityTransform: CATransform3D = {
		var transform = CATransform3DIdentity
		transform.m34 = CGFloat(1.0 / -500.0)
		transform = CATransform3DRotate(transform, CGFloat(-90.0).toRadians(), 0.0, 0.0, 1.0)
		return transform
	}()

	// MARK: -
	// MARK: Constructors

	public override init() {
		super.init(frame: .zero)

		shapeLayer.lineWidth = 1.0
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.strokeColor = tintColor.cgColor
		shapeLayer.actions = ["strokeEnd": NSNull(), "transform": NSNull()]
		shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		layer.addSublayer(shapeLayer)
		self.tintColor = Color.white
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: -
	// MARK: Methods

	override open func setPullProgress(_ progress: CGFloat) {
		super.setPullProgress(progress)

		shapeLayer.strokeEnd = min(0.9 * progress, 0.9)

		if progress > 1.0 {
			let degrees = ((progress - 1.0) * 200.0)
			shapeLayer.transform = CATransform3DRotate(identityTransform, degrees.toRadians(), 0.0, 0.0, 1.0)
		} else {
			shapeLayer.transform = identityTransform
		}
	}

	override open func startAnimating() {
		super.startAnimating()

		if shapeLayer.animation(forKey: kRotationAnimation) != nil {
			return
		}

		let ra = CABasicAnimation(keyPath: "transform.rotation.z")
		ra.toValue = CGFloat(2 * Double.pi) + currentDegree()
		ra.duration = 1.0
		ra.repeatCount = Float.infinity
		ra.isRemovedOnCompletion = false
		ra.fillMode = CAMediaTimingFillMode.forwards
		shapeLayer.add(ra, forKey: kRotationAnimation)
	}

	override open func stopLoading() {
		super.stopLoading()
		shapeLayer.removeAnimation(forKey: kRotationAnimation)
	}

	fileprivate func currentDegree() -> CGFloat {
		return shapeLayer.value(forKeyPath: "transform.rotation.z") as! CGFloat
	}

	override open func tintColorDidChange() {
		super.tintColorDidChange()

		shapeLayer.strokeColor = tintColor.cgColor
	}

	// MARK: -
	// MARK: Layout

	override open func layoutSubviews() {
		super.layoutSubviews()
		shapeLayer.frame = bounds
		let inset = shapeLayer.lineWidth / 2.0
		shapeLayer.path = UIBezierPath(ovalIn: shapeLayer.bounds.insetBy(dx: inset, dy: inset)).cgPath
	}

}
