//
// Created by entaoyang on 2019-01-25.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
public typealias ImagePickBlock = (UIImage) -> Void

open class ImagePickPage: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	public var limitWidth: CGFloat = 0

	public var onResult: ImagePickBlock = { _ in
	}

	public func fromGallery() -> Bool {
		if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			return false
		}
		self.delegate = self
		self.sourceType = .photoLibrary
		return true
	}

	public func fromCamera() -> Bool {
		if !UIImagePickerController.isSourceTypeAvailable(.camera) {
			return false
		}
		self.delegate = self
		self.sourceType = .camera
		return true

	}

	@objc
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		let img: UIImage
		if self.allowsEditing {
			img = info[.editedImage] as! UIImage
		} else {
			img = info[.originalImage] as! UIImage
		}
		var m: UIImage = img
		if self.limitWidth > 0 {
			m = img.limitTo(self.limitWidth)
		}
		picker.dismiss(animated: true)
		onResult(m)
		onResult = { _ in
		}
	}

	@objc
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		onResult = { _ in
		}
		picker.dismiss(animated: true)
	}

}

public extension UIViewController {
	func selectImageLimit(_ limitWidth: CGFloat, _ resultBlock: @escaping ImagePickBlock) {
		self.selectImage({ $0.limitWidth = limitWidth }, resultBlock)
	}

	func selectImage(_ configBlock: @escaping (ImagePickPage) -> Void, _ resultBlock: @escaping ImagePickBlock) {
		let p = SheetPage(self)
		p.addAction("拍摄", "camera") {
			self.openCamera(configBlock, resultBlock)
		}
		p.addAction("从相册选择", "gallery") {
			self.openGallery(configBlock, resultBlock)
		}
		p.show()

	}

	func openGallery(_ configBlock: @escaping (ImagePickPage) -> Void, _ resultBlock: @escaping ImagePickBlock) {
		PhotoPerm.authPhoto { [weak self] b in
			if let S = self {
				let p = ImagePickPage()
				if !p.fromGallery() {
					return
				}
				p.allowsEditing = true
				p.onResult = resultBlock
				configBlock(p)
				S.present(p)
			}
		}

	}

	func openGallery(_ block: @escaping ImagePickBlock) {
		self.openGallery({ _ in }, block)
	}

	func openCamera(_ block: @escaping ImagePickBlock) {
		self.openCamera({ _ in }, block)
	}

	func openCamera(_ configBlock: @escaping (ImagePickPage) -> Void, _ resultBlock: @escaping ImagePickBlock) {
		PhotoPerm.authCameraVideo { [weak self] b in
			if let S = self {
				let p = ImagePickPage()
				if !p.fromCamera() {
					return
				}
				p.allowsEditing = true
				p.onResult = resultBlock
				configBlock(p)
				S.present(p)
			}
		}
	}
}