//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

open class InputPage: ItemPage {
	public var textValue: String = ""
	public var hint: String = "请输入"
	public var resultBlock: (String) -> Void = { _ in
	}

	open override func onCreateContent() {
		super.onCreateContent()
		titleBar.back()
		titleBar.title = self.title

		hideKeyboardOnClick()

		makeEdit(hint) {
			$0.editView.returnDone()
			$0.editView.text = textValue
		}

		makeButtonGreen("保存").click { [weak self] _ in
			self?.onSave()
		}
	}

	open func onSave() {
		if !self.checkValid() {
			return
		}
		let s = getInputText(hint)
		self.close()
		resultBlock(s)
	}
}