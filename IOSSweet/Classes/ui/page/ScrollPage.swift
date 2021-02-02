//
// Created by entaoyang on 2019-02-20.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

open class ScrollPage: TitlePage {
	public let scrollView: VerticalScrollView = VerticalScrollView(frame: .zero)

	open override func onCreateContent() {
		super.onCreateContent()
		self.contentView.addSubview(self.scrollView)
		self.scrollView.layout.fill()

	}

}