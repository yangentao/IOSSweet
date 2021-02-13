//
// Created by entaoyang@163.com on 2017/10/13.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit
import SwiftSweet
public typealias Image = UIImage

public extension UIImage {

	static func tabBarNamed(_ name: String) -> UIImage {
		return UIImage.namedImage(name).scaledTo(Theme.TabBar.imageSize)//.renderRaw
	}

	static func namedImage(_ name: String) -> UIImage {
		let img = UIImage(named: name)
		if img == nil {
			logd("Image NOT found ", name)
		}
		return img!
	}

	static func colored(_ color: UIColor) -> UIImage {
		return colored(color, 2, 2)
	}

	static func colored(_ color: UIColor, _ w: CGFloat, _ h: CGFloat) -> UIImage {
		let r = Rect.sized(w, h)
		return graphic(r.size) { c in
			c.setFillColor(color.cgColor)
			c.fill(r)
		}
	}

	static func roundColored(_ color: UIColor, _ w: CGFloat, _ h: CGFloat, _ corner: CGFloat) -> UIImage {
		let r = Rect.sized(w, h)
		return graphic(r.size) { c in
			c.setFillColor(color.cgColor)
			let b = UIBezierPath(roundedRect: r, cornerRadius: corner)
			b.fill()
		}
	}

	static func graphic(_ w: CGFloat, _ h: CGFloat, _ block: (CGContext) -> Void) -> UIImage {
		return graphic(Size.sized(w, h), block)
	}

	static func graphic(_ size: CGSize, _ block: (CGContext) -> Void) -> UIImage {
		UIGraphicsBeginImageContext(size)
		let c = UIGraphicsGetCurrentContext()!
		block(c)
		let img = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return img
	}

	var renderRaw: UIImage {
		return self.withRenderingMode(.alwaysOriginal)
	}

	var resizable: UIImage {
		let sz = self.size
		let top = (sz.height - 1) / 2
		let left = (sz.width - 1) / 2
		let inset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
		return self.resizableImage(withCapInsets: inset, resizingMode: .stretch)
	}

	func limitTo(_ w: CGFloat) -> UIImage {
		if w > 0 && self.size.width > 0 && self.size.width > w {
			let h = self.size.height * w / self.size.width
			return scaledTo(w, h)
		}
		return self
	}

	func scaledTo(_ w: CGFloat) -> UIImage {
		if self.size.width > 0 {
			let h = self.size.height * w / self.size.width
			return scaledTo(w, h)
		}
		return self
	}

	func scaledTo(_ w: CGFloat, _ h: CGFloat) -> UIImage {
		return Image.graphic(w, h) { c in
			self.draw(in: Rect.sized(w, h))
		}
	}

	func scaledBy(_ f: CGFloat) -> UIImage {
		let w = self.size.width * f
		let h = self.size.height * f

		return Image.graphic(w, h) { c in
			self.draw(in: Rect.sized(w, h))
		}
	}

	func rounded(_ corner: CGFloat) -> UIImage {
		let r = Rect.sized(self.size)
		return Image.graphic(r.size) { c in
			UIBezierPath(roundedRect: r, cornerRadius: corner).addClip()
			self.draw(in: r)
		}
	}

	func tinted(_ color: UIColor) -> UIImage {
		let r = Rect.sized(self.size)
		return Image.graphic(r.size) { c in
			c.setFillColor(color.cgColor)
			c.fill(r)
			self.draw(in: r, blendMode: .destinationIn, alpha: 1.0)
		}
	}

	//给它加一个圆形背景色, 直径 =  原图形对角线长度 + 2 * edge
	func backOval(ovalColor: UIColor, edge: CGFloat = 0, tintColor: UIColor = UIColor.white) -> UIImage {
		let r = Rect.sized(self.size)
		let maxEdge = sqrt(r.height * r.height + r.width * r.width) + 2 * edge
		let backRect = Rect.sized(maxEdge)
		let drawRect = Rect.make((backRect.width - r.width) / 2, (backRect.height - r.height) / 2, r.width, r.height)

		let tintedImage = tinted(tintColor)
		return Image.graphic(backRect.size) { c in
			c.setFillColor(ovalColor.cgColor)
			let b = UIBezierPath(arcCenter: backRect.center, radius: backRect.width / 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
			b.addClip()
			b.fill()
			tintedImage.draw(in: drawRect)
		}
	}

	//给它加一个圆角矩形背景色, 新高 = 新宽 =  原图形对角线长度 + 2 * edge
	func backRound(ovalColor: UIColor, edge: CGFloat = 0, tintColor: UIColor = UIColor.white) -> UIImage {
		let r = Rect.sized(self.size)
		let maxEdge = sqrt(r.height * r.height + r.width * r.width) + 2 * edge
		let corner: CGFloat = maxEdge / 8.0
		let backRect = Rect.sized(maxEdge)
		let drawRect = Rect.make((backRect.width - r.width) / 2, (backRect.height - r.height) / 2, r.width, r.height)

		let tintedImage = tinted(tintColor)
		return Image.graphic(backRect.size) { c in
			c.setFillColor(ovalColor.cgColor)
			let b = UIBezierPath(roundedRect: backRect, cornerRadius: corner)
			b.addClip()
			b.fill()
			tintedImage.draw(in: drawRect)
		}
	}

	func saveTo(_ file: String) {
		if let data = self.pngData() {
			try? data.write(to: URL(fileURLWithPath: file))
		}
	}

}


