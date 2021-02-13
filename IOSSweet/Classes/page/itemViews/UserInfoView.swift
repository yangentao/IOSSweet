//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit


public class UserView: UIView {
	public let iconView: UIImageView = UIImageView.Default
	public let textView: UILabel = UILabel(frame: .zero)
	public let statusView: UILabel = UILabel(frame: .zero)


	public init() {
		super.init(frame: .zero)
		self.backgroundColor = .white
		self.addSubview(iconView)
		self.addSubview(textView)
		self.addSubview(statusView)
		iconView.layout.height(iconSize).width(iconSize).centerYParent().leftParent(Dim.edge)
		textView.layout.toRightOf(iconView, Dim.edge).rightParent(-Dim.edge).centerYParent(-13).height(25)
		statusView.layout.toRightOf(iconView, Dim.edge).rightParent(-Dim.edge).centerYParent(13).height(25)
		textView.stylePrimary()
		statusView.styleMinor()

		self.itemStyle(Dim.itemHeightLarge)
		self.ivMoreArrow = true
		iconView.roundLayer(6)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public var iconSize: CGFloat = Dim.iconSize2 {
		didSet {
			let L = iconView.layout
			L.height.eq(iconSize).update()
			L.width.eq(iconSize).update()
		}
	}
}