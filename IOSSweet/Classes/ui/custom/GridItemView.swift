//
// Created by entaoyang@163.com on 2017/10/16.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

open class GridItemView: UIView {
	public var imageView: UIImageView = UIImageView.Default
	public var labelView: UILabel = UILabel()

	private let TextHeight = Theme.Edit.heightMini

	public var iconSize: CGFloat = 48 {
		didSet {
			let L = self.imageView.layout
			L.width.eq(self.iconSize).update()
			L.height.eq(self.iconSize).update()
		}
	}

	public var data: Any?

	public var image: UIImage? {
		get {
			return imageView.image
		}
		set {
			let img: UIImage? = newValue
			imageView.image = img?.scaledTo(iconSize)
		}
	}
	public var text: String {
		get {
			return labelView.text ?? ""
		}
		set {
			labelView.text = newValue
		}
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		self.addSubview(imageView)
		self.addSubview(labelView)

		labelView.layout.bottomParent(0).height(TextHeight).fillX()
		imageView.layout.centerXParent().size(iconSize).above(labelView, 0)

		labelView.textColor = Theme.Text.minorColor
		labelView.font = Font.sys(12)
		labelView.alignCenter()
		self.roundLayer(6)
		self.setupFeedback()
	}

	public convenience init(icon: UIImage?, text: String) {
		self.init()
		self.image = icon
		self.text = text
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public static var Default: GridItemView {
		return GridItemView(frame: Rect.zero)
	}
}