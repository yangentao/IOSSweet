//
// Created by entaoyang on 2019-02-20.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit


//竖直滚动 例子
//self.view.addView(UIScrollView(frame: .zero).backColor(.blue)).apply { sv in
//	sv.layout.fill()
//	sv.addView(UIView(frame: .zero).backColor(.green)).apply { cv in
//		cv.layout {
//			$0.fill().widthOfParent()
////            $0.heightOfParent(multi: 1.5, constant: 0)
////            $0.height(900)
//		}
//
//		cv.addView(UILabel.Primary.named("a").backColor(.cyan)).apply { lb in
//			lb.layout.topParent().leftParent().widthOfParent().height(900)
//			lb.layout.bottomOf(cv)
//		}
//	}
//}


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
