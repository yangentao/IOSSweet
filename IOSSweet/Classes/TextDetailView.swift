//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class TextDetailView: UIView {
	public let textView: UILabel = UILabel.Primary
	public let detailView: UILabel = UILabel.Minor

	public init() {
		super.init(frame: .zero)
		self.backgroundColor = .white
		self.addSubview(textView)
		self.addSubview(detailView)

		textView.layout.centerYParent().heightEdit().leftParent(0)
		let L = detailView.layout.centerYParent().heightEdit().rightParent(0)
		L.toRightOf(textView)

		textView.stretchContent(.horizontal)
		detailView.keepContent(.horizontal)

		detailView.align(.right)
		self.itemStyle(Dim.itemHeightNormal)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}