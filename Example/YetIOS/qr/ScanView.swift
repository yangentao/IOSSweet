//
// Created by entaoyang on 2019-03-07.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public typealias ScanResultBlock = (String) -> Void

open class ScanView: UIView {
	private var animView: UIView = UIView(frame: .zero)
	public var color: UIColor = .green {
		didSet {
			self.animView.backgroundColor = self.color
		}
	}

	private var scanner: QRScaner? = nil

	public var onScanSuccess: ScanResultBlock = { _ in
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.addSubview(self.animView)
		self.animView.layout.leftParent(10).rightParent(-10).centerYParent().height(3)
		self.animView.backgroundColor = self.color
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func draw(_ rect: CGRect) {
		guard  let c = UIGraphicsGetCurrentContext() else {
			return
		}
		let color = self.color.cgColor
		c.setFillColor(color)
		let A: CGFloat = 4
		let B: CGFloat = 4
		let topLeft1 = Rect(x: rect.origin.x, y: rect.origin.y, width: A, height: B * A)
		let topLeft2 = Rect(x: rect.origin.x, y: rect.origin.y, width: B * A, height: A)
		c.fill([topLeft1, topLeft2])

		let topRight1 = Rect(x: rect.maxX - A, y: rect.origin.y, width: A, height: B * A)
		let topRight2 = Rect(x: rect.maxX - B * A, y: rect.origin.y, width: B * A, height: A)
		c.fill([topRight1, topRight2])

		let leftBottom1 = Rect(x: rect.minX, y: rect.maxY - B * A, width: A, height: B * A)
		let leftBottom2 = Rect(x: rect.minX, y: rect.maxY - A, width: B * A, height: A)
		c.fill([leftBottom1, leftBottom2])

		let rightBottom1 = Rect(x: rect.maxX - A, y: rect.maxY - B * A, width: A, height: B * A)
		let rightBottom2 = Rect(x: rect.maxX - B * A, y: rect.maxY - A, width: B * A, height: A)
		c.fill([rightBottom1, rightBottom2])

		c.setStrokeColor(color)
		c.setLineWidth(1)
		let points = [CGPoint(x: rect.minX + A, y: rect.minY + A),
		              CGPoint(x: rect.minX + A, y: rect.maxY - A),
		              CGPoint(x: rect.maxX - A, y: rect.maxY - A),
		              CGPoint(x: rect.maxX - A, y: rect.minY + A)]
		c.addLines(between: points)
		c.closePath()
		c.strokePath()

	}

	private var page: UIViewController? {
		return self.findMyController()
	}

	private func startScan() {
		if !UIImagePickerController.isSourceTypeAvailable(.camera) {
			self.page?.dialog.showAlert("初始化相机失败")
			return
		}
		guard let device: AVCaptureDevice = AVCaptureDevice.default(for: .video) else {
			self.page?.dialog.showAlert("初始化相机失败")
			return
		}
		guard let devInput = try? AVCaptureDeviceInput(device: device) else {
			self.page?.dialog.showAlert("初始化相机失败")
			return
		}

		let q = QRScaner(device: device, devInput: devInput, videoView: self.superview!, interestRect: self.frame)

		q.successBlock = { r in
			self.onScanSuccess(r.text)
		}
		self.scanner = q
		q.start()

		UIView.animate(withDuration: 1.5, delay: 0.1, options: [.autoreverse, .repeat, .curveLinear], animations: {
			let rect = self.animView.frame
			self.animView.frame = Rect(x: rect.minX + 50, y: rect.minY, width: rect.width - 100, height: rect.height)
		})

	}

	public func start() {
		PhotoPerm.authCameraVideo { [weak self] b in
			self?.startScan()
		}
	}

	public func stop() {
		self.scanner?.stop()
		self.scanner = nil
		self.animView.layer.removeAllAnimations()
		self.setNeedsLayout()
	}

	public func toggleTorch() {
		self.scanner?.toggleTorch()
	}

	public var isTorchOn: Bool {
		return self.scanner?.isTorchOn ?? false
	}

	public func setTorch(torch: Bool) {
		self.scanner?.setTorch(torch: torch)
	}

	public var hasTorch: Bool {
		return self.scanner?.hasTorch ?? false
	}
}