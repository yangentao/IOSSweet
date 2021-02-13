//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit


public class InputView: UIView {
	public let editView: UITextField = UITextField.Round

	public init() {
		super.init(frame: .zero)
		self.backgroundColor = .white
		self.addSubview(editView)
		editView.layout.centerYParent().heightEdit().leftParent(0).rightParent(0)
		self.itemStyleInput()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	@discardableResult
	public func pwd() -> InputView {
		editView.pwd()
		return self
	}

}