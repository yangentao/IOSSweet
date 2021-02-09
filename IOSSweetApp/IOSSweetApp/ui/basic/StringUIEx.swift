//
// Created by entaoyang@163.com on 2019/9/20.
// Copyright (c) 2019 entao.dev. All rights reserved.
//

import UIKit

public func htmlStr(_ font: UIFont, _ s: String) -> NSAttributedString {
	let ss = try? NSMutableAttributedString(data: s.dataUnicode, options: [
		NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
	], documentAttributes: nil)
	if let sss = ss {
		sss.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: sss.length))
		return sss
	}
	return NSAttributedString(string: s)
}

public extension NSAttributedString {

	func linkfy() -> NSMutableAttributedString {
		let s = NSMutableAttributedString(attributedString: self)

		guard let detect = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue) else {
			return s
		}
		let ms = detect.matches(in: s.string, range: NSRange(location: 0, length: s.length))
		for m in ms {
			if m.resultType == .link, let url = m.url {
				s.addAttributes([NSAttributedString.Key.link: url,
				                 NSAttributedString.Key.foregroundColor: UIColor.blue,
				                 NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue
				], range: m.range)
			} else if m.resultType == .phoneNumber, let pn = m.phoneNumber {
				s.addAttributes([NSAttributedString.Key.link: pn,
				                 NSAttributedString.Key.foregroundColor: UIColor.blue,
				                 NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue
				], range: m.range)
			}
		}
		return s
	}

}