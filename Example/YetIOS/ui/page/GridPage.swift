//
// Created by entaoyang on 2019-03-02.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit

//itemView不复用! 适合小量数据
open class GridPage<T>: BasePage {

    public let scrollView: UIScrollView = UIScrollView(frame: .zero)
    public let gridView: GridLayout = GridLayout(frame: .zero)
    public var binder: (T, ImageLabelView) -> Void = { item, v in
        v.labelView.text = "\(item)"
        v.imageView.image = UIImage.namedImage("a.png")
    }
    public var itemClickCallback: (T) -> Void = { _ in
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addView(self.scrollView).constraints { c in
            c.edgeXParent()
        }.topAnchorParentSafeArea().bottomAnchorParentSafeArea()

        scrollView.addView(gridView).constraints { c in
            c.edgesParent()
            c.widthParent()
        }.spaces(2, 8)

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


    open func setItems(_ ls: [T]) {
        self.gridView.removeAllChildView()
        for item in ls {
            let v = ImageLabelView(frame: .zero).vertical()
            self.gridView.addSubview(v)
            onBind(item, v)
            v.clickView { [weak self] v in
                self?.onItemClick(item)
            }
        }
    }

    open func requestItems() {
        Task.back { [weak self] in
            if let ls = self?.onRequestItems() {
                Task.fore {
                    self?.setItems(ls)
                }
            }
        }
    }

    open func onItemClick(_ item: T) {
        itemClickCallback(item)
    }


    open func onBind(_ item: T, _ view: ImageLabelView) {
        binder(item, view)
    }

    open func onRequestItems() -> [T] {
        return []
    }
}
