//
// Created by entaoyang@163.com on 2019/9/25.
//

import Foundation
import UIKit

open class MyLabel: UILabel {

	public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

	open override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: textInsets))
	}
}