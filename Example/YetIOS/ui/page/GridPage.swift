//
// Created by entaoyang on 2019-03-02.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

//itemView不复用!
open class GridPage<T>: ScrollPage {

	open override func onCreateContent() {
		super.onCreateContent()

	}

	open func setItems(_ ls: [T]) {
		let oldChildren = self.scrollView.contentVertical.subviews
		for v in oldChildren {
			if v is GridItemView {
				v.removeFromSuperview()
			}
		}
		self.scrollView.layoutScrollGrid { L in
			L.edge(l: 20, t: 10, r: 20, b: 20)
			self.onConfigGrid(L)
			for b in ls {
				let v = GridItemView()
				self.onBind(b, v)
				v.data = b
				v.clickView { [weak self] vv in
					self?.onItemClick((vv as! GridItemView).data as! T)
				}
				L.add(v)
			}
		}
	}

	open func requestItems() {
		Task.back { [weak self] in
			if let ls = self?.onRequestItems() {
				Task.fore {
					self?.setItems(ls)
				}
			}
		}
	}

	open func onItemClick(_ item: T) {

	}

	open func onConfigGrid(_ L: GridLayoutConstraint) {

	}

	open func onBind(_ item: T, _ view: GridItemView) {

	}

	open func onRequestItems() -> [T] {
		return []
	}
}