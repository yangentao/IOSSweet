//
// Created by entaoyang on 2019-03-07.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet

open class QRPage: TitlePage {
	private let btnSize: CGFloat = 64
	private let bottomOffset: CGFloat = 70
	private let btnSep: CGFloat = 30
	private let imgLight = "yet_qr_light"
	private let imgQR = "yet_qr_input"
	private let imggallary = "yet_qr_gallary"

	public var allowManual: Bool = true
	public var allowTorch: Bool = true
	public var allowGallary: Bool = true
	public var titleText: String = "扫一扫"

	public private(set) var scanView: ScanView = ScanView(frame: .zero)

	public var onResult: (String) -> Void = { _ in
	}

	open override func onCreateContent() {
		super.onCreateContent()
		self.titleBar.title = self.titleText

		self.contentView.backgroundColor = .darkGray
		self.contentView.addSubview(self.scanView)
		self.scanView.layout.size(240).centerYParent(-50).centerXParent()
		self.scanView.onScanSuccess = { [weak self] s in
			self?.scanSuccess(s)
		}

		var bs = [UIButton]()
		if self.allowManual {
			bs += self.makeButton(imgQR, imgQR + "2")
		}
		if self.allowTorch {
			bs += self.makeButton(imgLight, imgLight + "2")
		}
		if self.allowGallary {
			bs += self.makeButton(imggallary, imggallary + "2")
		}
		for b in bs {
			self.contentView.addSubview(b)
		}

		switch bs.count {
		case 1:
			bs[0].layout.below(self.scanView, bottomOffset).size(btnSize).centerXParent()
		case 2:
			bs[0].layout.below(self.scanView, bottomOffset).size(btnSize).centerXParent(-btnSize / 2 - btnSep / 2)
			bs[1].layout.below(self.scanView, bottomOffset).size(btnSize).centerXParent(btnSize / 2 + btnSep / 2)
		case 3:
			bs[1].layout.below(self.scanView, bottomOffset).size(btnSize).centerXParent()
			bs[0].layout.below(self.scanView, bottomOffset).size(btnSize).toLeftOf(bs[1], -btnSep)
			bs[2].layout.below(self.scanView, bottomOffset).size(btnSize).toRightOf(bs[1], btnSep)
		default:
			break
		}
	}

	private func findImg(_ img: String) -> String {
		return resOf(cls: QRPage.self, res: img)
	}

	private func makeButton(_ img: String, _ img2: String) -> UIButton {
		let b = UIButton(frame: .zero)
		b.setImage(UIImage(named: findImg(img))?.scaledTo(btnSize - 4), for: .normal)
		b.setImage(UIImage(named: findImg(img2))?.scaledTo(btnSize - 4), for: .highlighted)
		b.setImage(UIImage(named: findImg(img2))?.scaledTo(btnSize - 4), for: .selected)
		b.tagS = img
		b.click(self, #selector(onClickButton(b:)))
		return b
	}

	@objc
	private func onClickButton(b: UIButton) {
		switch b.tagS {
		case self.imgLight:
			self.scanView.toggleTorch()
			b.isSelected = self.scanView.isTorchOn
		case self.imgQR:
			self.inputQR()
		case self.imggallary:
			self.fromGallary()
		default:
			break
		}
	}

	private func inputQR() {
		self.dialog.showInput(title: "请输入编码", text: "") { [weak self] s in
			if s.notEmpty {
				self?.scanSuccess(s)
			}
		}
	}

	private func fromGallary() {
		self.selectImageLimit(1000) { [weak self] img in
			if let r = QR.recognizeQRImage(image: img) {
				self?.scanSuccess(r.text)
			}

		}
	}

	private func scanSuccess(_ s: String) {
		logd("ScanResult: ", s)
		self.scanView.stop()
		self.close()
		self.onResult(s)
		self.onResult = { _ in
		}
	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.scanView.start()
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.scanView.stop()
	}

}