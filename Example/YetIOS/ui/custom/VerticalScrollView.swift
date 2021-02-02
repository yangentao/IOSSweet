//
// Created by entaoyang on 2019-02-20.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

open class VerticalScrollView: UIScrollView {

	public var contentVertical: UIView = UIView(frame: .zero)

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(self.contentVertical)
		let L = self.contentVertical.layout.fill()
		L.width.eqParent.active()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

//	open func layoutScrollVertical(_ block: (VerticalLayout) -> Void) {
//		let L = VerticalLayout(self.contentVertical)
//		block(L)
//		L.install(true)
//	}

	open func layoutScrollGrid(_ block: (GridLayout) -> Void) {
		let L = GridLayout(self.contentVertical)
		block(L)
		L.install(true)
	}
}
