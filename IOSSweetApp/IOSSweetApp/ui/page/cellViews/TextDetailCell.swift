//
// Created by entaoyang@163.com on 2017/10/19.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

//TEXT          DETAIL

public class TextDetailCell: UITableViewCell {
	public var keyPos: Int = 0
	public var keyN: Int = 0
	public var keyS: String = ""
	public weak var keyObj: AnyObject? = nil

	public init(_ reuse: String) {
		super.init(style: .value1, reuseIdentifier: reuse)
		self.textLabel?.textColor = Theme.Text.primaryColor
		self.detailTextLabel?.textColor = Theme.Text.minorColor
		self.textLabel?.stylePrimary()
		self.detailTextLabel?.styleMinor()
		self.backgroundColor = .white
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	@discardableResult
	public func bindValues(_ text: String, _ detail: String? = nil) -> TextDetailCell {
		self.textLabel?.text = text
		self.detailTextLabel?.text = detail
		return self
	}

	@discardableResult
	public func bindValue(_ text: String) -> TextDetailCell {
		return bindValues(text, nil)
	}

	@discardableResult
	public func setColors(_ textColor: UIColor, _ detailColor: UIColor? = nil) -> TextDetailCell {
		self.textLabel?.textColor = textColor
		if detailColor != nil {
			self.detailTextLabel?.textColor = detailColor
		}
		return self
	}

}