//
// Created by entaoyang on 2019-01-24.
// Copyright (c) 2019 yet.net. All rights reserved.
//

import Foundation
import UIKit


public class TextImageView: UIView {
    public let textView: UILabel = UILabel.Primary
    public let imageView: UIImageView = UIImageView.Default

    public override init(frame: CGRect) {
        super.init(frame: Rect.zero)
        self.backgroundColor = .white
        self.addSubview(textView)
        self.addSubview(imageView)

        imageView.layout.centerYParent().size(Dim.iconSize2).rightParent(0)
        textView.layout.centerYParent().heightEdit().leftParent(0).toLeftOf(imageView, -Dim.edge)
        self.itemStyle(Dim.itemHeightLarge)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}