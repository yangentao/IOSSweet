//
// Created by entaoyang on 2018-12-29.
// Copyright (c) 2018 yet.net. All rights reserved.
//

import Foundation
import UIKit

//import Kingfisher

public extension UIImageView {

	static var makeDefault: UIImageView {
		return UIImageView.Default
	}
	static var Default: UIImageView {
		let v = UIImageView(frame: Rect.zero)
		v.scaleAspectFill()
		v.clipsToBounds = true
		return v
	}

	func nameThemed(_ name: String) {
		self.image = UIImage(named: name)?.tinted(Theme.themeColor)
	}

	func namedImage(_ name: String) {
		self.image = UIImage(named: name)
	}

	func namedImage(_ name: String, _ w: CGFloat) {
		self.image = UIImage(named: name)?.scaledTo(w)
	}

	func alignCenter() {
		self.contentMode = .center
	}

	func alignLeft() {
		self.contentMode = .left
	}

	func alignRight() {
		self.contentMode = .right
	}

	func alignTop() {
		self.contentMode = .top
	}

	func alignBottom() {
		self.contentMode = .bottom
	}

	func alignTopLeft() {
		self.contentMode = .topLeft
	}

	func alignTopRight() {
		self.contentMode = .topRight
	}

	func alignBottomLeft() {
		self.contentMode = .bottomLeft
	}

	func alignBottomRight() {
		self.contentMode = .bottomRight
	}

	func scaleAspectFit() {
		self.contentMode = .scaleAspectFit
	}

	func scaleFill() {
		self.contentMode = .scaleToFill
	}

	func scaleAspectFill() {
		self.contentMode = .scaleAspectFill
	}

}