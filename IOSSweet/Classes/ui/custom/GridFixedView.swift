//
// Created by entaoyang@163.com on 2017/10/17.
// Copyright (c) 2017 yet.net. All rights reserved.
//

import Foundation
import UIKit

public class GridData {
	public var label: String = ""
	public var image: UIImage?
	public var keyS: String = ""
	public var keyN: Int = 0

	public init(label: String, image: String) {
		self.label = label
		self.image = UIImage(named: image)
	}

}

//适合少量数据
public class GridFixedView: UIView {

	private var items: [GridData] = [GridData]()
	public var edge: Edge = Edge()

	public var cellWidth: CGFloat = 80
	public var cellHeight: CGFloat = 80
	public var verticalSpace: CGFloat = 10
	public var columns: Int = 3 {
		didSet {
			if columns < 1 {
				self.columns = 1
			}
		}
	}

	public var rowCount: Int {
		let c = self.items.count
		return c / self.columns + (c % self.columns == 0 ? 0 : 1)
	}

	public var onBindItemView: (GridData, GridItemView) -> Void = { item, view in
		view.image = item.image
		view.text = item.label
		view.data = item
	}

	open var onItemClick: (GridData) -> Void = { item in
		logd("click \(item.label)")
	}

	public init() {
		super.init(frame: Rect.zero)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	public var totalHeight: CGFloat {
		var a: CGFloat = edge.top + edge.bottom
		let rows = self.rowCount
		if rows > 0 {
			a += self.cellHeight * rows
			a += self.verticalSpace * (rows - 1)
		}
		return a
	}

	public func edge(l: CGFloat, t: CGFloat, r: CGFloat, b: CGFloat) {
		self.edge.left = l
		self.edge.top = t
		self.edge.right = r
		self.edge.bottom = b
	}

	public override var intrinsicContentSize: CGSize {
		return sizeThatFits(Size.zero)
	}

	public override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CGSize(width: self.frame.width, height: rowCount.f * cellHeight)
	}

	public func setData(_ items: [GridData]) {
		self.removeAllChildView()
		self.items = items
		for it in items {
			let v = GridItemView(icon: it.image, text: it.label)
			v.data = it
			addSubview(v)
			onBindItemView(it, v)
			v.clickView { [weak self] v in
				self?.onItemClick((v as! GridItemView).data as! GridData)
			}
		}
		setNeedsLayout()
	}

	private func rectOf(_ n: Int, _ parentWidth: CGFloat) -> CGRect {
		let row = (n + 1) / self.columns + ((n + 1) % self.columns == 0 ? 0 : 1) - 1
		let y: CGFloat = self.edge.top + self.cellHeight * row + self.verticalSpace * row
		let x: CGFloat
		if n == 0 {
			x = self.edge.left
		} else if self.columns <= 1 {
			x = (parentWidth - self.cellWidth) / 2
		} else {
			let col = n % columns
			//Parent.width = edge.left + edge.right + self.columns * self.cellWidth + (self.columns -1) * horSpace
			var horSpace: CGFloat = (parentWidth - self.edge.left - self.edge.right - self.cellWidth * self.columns) / (self.columns - 1)
			if horSpace < 0 {
				horSpace = 0
			}
			x = self.edge.left + self.cellWidth * col + horSpace * col
		}
		return CGRect(x: x, y: y, width: self.cellWidth, height: self.cellHeight)

	}

	private func arrangeViews() {
		let myWidth: CGFloat = self.frame.width
		for n in self.subviews.indices {
			let v: UIView = self.subviews[n]
			let r = rectOf(n, myWidth)
			v.frame = r
		}
	}

	open override func layoutSubviews() {
		super.layoutSubviews()
		arrangeViews()
		if superview is UIScrollView {
			superview?.setNeedsUpdateConstraints()
		}
	}
}