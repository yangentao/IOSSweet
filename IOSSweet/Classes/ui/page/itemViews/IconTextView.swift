//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class IconTextView: UIView {
	public let iconView: UIImageView = UIImageView.Default
	public let textView: UILabel = UILabel(frame: .zero)

	public init() {
		super.init(frame: .zero)
		self.backgroundColor = .white
		self.addSubview(iconView)
		self.addSubview(textView)
		iconView.layout.height(iconSize).width(iconSize).centerYParent().leftParent(0)
		textView.layout.toRightOf(iconView, Dim.edge).rightParent(0).centerYParent().height(32)
		textView.stylePrimary()

		self.itemStyle(Dim.itemHeightNormal)
		self.setupFeedback()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public var iconSize: CGFloat = Dim.iconSize {
		didSet {
			let L = iconView.layout
			L.height.eq(iconSize).update()
			L.width.eq(iconSize).update()
		}
	}
}