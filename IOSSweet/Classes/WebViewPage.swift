//
// Created by entaoyang on 2019-02-14.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit
import WebKit

open class WebViewPage: TitlePage {

	public let webView: WKWebView = WKWebView(frame: .zero)

	open override func onCreateContent() {
		super.onCreateContent()
		titleBar.back()
		contentView.addSubview(webView)
		webView.layout.fill()
        webView.allowsBackForwardNavigationGestures = true 

	}
}
