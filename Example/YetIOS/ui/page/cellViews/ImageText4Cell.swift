//
// Created by entaoyang@163.com on 2017/10/19.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

//TEXT              TIME
//MSG               STATUS

//最小高度 54

public class ImageText4Cell: UITableViewCell {
	public var iconView = UIImageView.Default
	public var textView = UILabel(frame: Rect.zero)
	public var timeView = UILabel(frame: Rect.zero)
	public var msgView = UILabel(frame: Rect.zero)
	public var statusView = UILabel(frame: Rect.zero)

	public var iconSize: CGFloat = 36 {
		didSet {
			let L = iconView.layout
			L.width.eq(iconSize).update()
			L.height.eq(iconSize).update()
		}
	}

	public var keyPos: Int = 0
	public var keyN: Int = 0
	public var keyS: String = ""
	public weak var keyObj: AnyObject? = nil

	public init(_ reuse: String) {
		super.init(style: .default, reuseIdentifier: reuse)
		self.backgroundColor = .white
		self.contentView.addSubview(iconView)
		self.contentView.addSubview(textView)
		self.contentView.addSubview(timeView)
		self.contentView.addSubview(msgView)
		self.contentView.addSubview(statusView)
		iconView.layout.width(iconSize).height(iconSize).centerYParent().leftParent(12)

		textView.layout { L in
			L.toRightOf(self.iconView, 10)
			L.centerYParent(-Theme.Text.height / 2)
			L.heightText()
		}
		timeView.layout { L in
			L.rightParent(-10)
			L.top.eq(textView).active()
			L.height(Theme.Text.heightMinor)
		}

		timeView.layout.toRightOf(textView)
		textView.stretchContent(.horizontal)
		timeView.keepContent(.horizontal)

		msgView.layout { L in
			L.toRightOf(self.iconView, 10)
			L.below(textView, 0)
			L.height(Theme.Text.heightMinor)
		}
		statusView.layout { L in
			L.rightParent(-10)
			L.top.eq(msgView).active()
			L.height(Theme.Text.heightMinor)
		}

		statusView.layout.toRightOf(msgView)
		msgView.stretchContent(.horizontal)
		statusView.keepContent(.horizontal)

		textView.stylePrimary()
		msgView.styleMinor()
		timeView.alignRight().styleMinor()
		statusView.alignRight().styleMinor()

	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public func bindValues(_ text: String, _ time: String, _ msg: String, _ status: String) {
		textView.text = text
		msgView.text = msg
		timeView.text = time
		statusView.text = status
	}
}