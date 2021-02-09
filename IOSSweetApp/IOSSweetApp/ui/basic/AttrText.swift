//
// Created by entaoyang on 2019-02-19.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

//let at = AttrText(item.body).lineSpace(8).font(Fonts.regular(16)).foreColor(Theme.Text.primaryColor).indent(32).value
//lb.attributedText = at
public class AttrText {

	private var dic: [NSAttributedString.Key: Any] = [NSAttributedString.Key: Any]()

	private var p: NSMutableParagraphStyle? = nil
	private var ps: NSMutableParagraphStyle {
		if p == nil {
			p = NSMutableParagraphStyle()
		}
		return p!
	}
	private let text: String

	public init(_ text: String) {
		self.text = text
	}

}

public extension AttrText {

	var value: NSAttributedString {
		return NSAttributedString(string: self.text, attributes: self.dic)
	}

	func lineBreakMode(_ n: NSLineBreakMode) -> AttrText {
		self.ps.lineBreakMode = n
		self.dic[.paragraphStyle] = self.ps
		return self
	}

	func alignment(_ n: NSTextAlignment) -> AttrText {
		self.ps.alignment = n
		self.dic[.paragraphStyle] = self.ps
		return self
	}

	func paragraphSpacing(_ n: CGFloat) -> AttrText {
		self.ps.paragraphSpacing = n
		self.dic[.paragraphStyle] = self.ps
		return self
	}

	func lineSpace(_ n: CGFloat) -> AttrText {
		self.ps.lineSpacing = n
		self.dic[.paragraphStyle] = self.ps
		return self
	}

	func indent(_ n: CGFloat) -> AttrText {
		self.ps.firstLineHeadIndent = n
		self.dic[.paragraphStyle] = self.ps
		return self
	}

	func foreColor(_ c: UIColor) -> AttrText {
		self.dic[.foregroundColor] = c
		return self
	}

	func backColor(_ c: UIColor) -> AttrText {
		self.dic[.backgroundColor] = c
		return self
	}

	func underlineStyle(_ b: NSUnderlineStyle) -> AttrText {
		self.dic[.underlineStyle] = b.rawValue
		return self
	}

	func underlineColor(_ c: UIColor) -> AttrText {
		self.dic[.underlineColor] = c
		return self
	}

	func shadow(_ c: NSShadow) -> AttrText {
		self.dic[.shadow] = c
		return self
	}

	func font(_ c: UIFont) -> AttrText {
		self.dic[.font] = c
		return self
	}
}