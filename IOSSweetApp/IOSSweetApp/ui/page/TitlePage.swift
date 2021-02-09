//
// Created by entaoyang on 2019-01-08.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

open class TitlePage: BasePage {

	private(set) public var contentView: UIView = UIView()

	open override func viewDidLoad() {
		super.viewDidLoad()
		self.contentView.backgroundColor = .white
		self.view.addSubview(contentView)
		contentView.layout.fillX()
		contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		if nil != self.tabBarController {
			titleBar.title = self.tabItemText
		}
		if let nv = self.navigationController {
			if nv.viewControllers.count > 1 && nv.topViewController === self {
				self.titleBar.back()
			}
		}
		self.preCreateContent()
		onCreateContent()
		afterCreateContent()
	}

	open func preCreateContent() {

	}

	open func onCreateContent() {

	}

	open func afterCreateContent() {

	}

}