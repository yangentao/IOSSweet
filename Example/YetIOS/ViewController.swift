//
//  ViewController.swift
//  YetIOS
//
//  Created by yangentao on 01/02/2021.
//  Copyright (c) 2021 yangentao. All rights reserved.
//

import UIKit

//import IOSSweet


extension MsgID {
    static let labelTextChanged = MsgID("msg.label.text.changed")
}

public class ImageLabelView: RelativeLayout {
    public private(set) lazy var imageView: UIImageView = NamedView(self, "imageView")
    public private(set) lazy var labelView: UILabel = NamedView(self, "labelView")
    public var textImageSpace: CGFloat = 0 {
        didSet {
            imageView.relativeParams?.updateConstant(.bottom, -textImageSpace)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews {
            UIImageView.Default.named("imageView").relativeParams { p in
                p.centerXParent().topParent(0).above("labelView", -textImageSpace).widthEQSelf(.height)
            }
            UILabel.Minor.named("labelView").align(.center).clipsToBounds(false).relativeParams { p in
//                p.centerXParent().bottomParent().height(30).widthEQParent()
                p.centerXParent().bottomParent().height(30).widthWrap(30)
            }
        }
        WatchCenter.listen(obj: labelView, keyPath: "text", actionTarget: self, action: #selector(Self.onLabelChanged))
    }

    @objc
    func onLabelChanged() {
        self.setNeedsLayout()

    }


    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class ViewController: UIViewController {
//    lazy var label: UILabel = NamedView(self, "a")


    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backColor(Colors.fill)

        self.view.addView(UILabel.Primary).apply { lb in
            lb.constraintSystem { b in
                b.centerX.eqParent()
                b.centerY.eqParent()
                b.width.eqParent(multi: 0.9)
                b.height.eqSelf(.width, multi: 0.5)
            }

            lb.numberOfLines = 0
            lb.backColor(.green)
//            lb.preferredMaxLayoutWidth = 100
            lb.text = "杨恩涛我问问www我问问呜呜呜呜呜呜呜呜杨恩涛我问问www我问问呜呜呜呜呜呜呜呜杨恩涛我问问www我问问呜呜呜呜呜呜呜呜"
        }
//        let a = self.view.addView(ImageLabelView(frame:  let a = self.view.addView(ImageLabelView(frame: .zero)).layout { L in
////            L.centerParent().size(100, 100)
////        }
////        a.imageView.namedImage("a.png")
////        a.labelView.text = "杨恩涛我问问www我问问呜呜呜呜呜呜呜呜"
//////        a.backColor(.green)
////
////        a.imageView.backColor(0x30888888.argb)
////        a.imageView.roundLayer(6)
////        a.labelView.backColor(.cyan)
//////        a.labelView.preferredMaxLayoutWidth = 100
////        a.labelView.layout.width(100)
////        a.labelView.numberOfLines = 0 .zero)).layout { L in
//            L.centerParent().size(100, 100)
//        }
//        a.imageView.namedImage("a.png")
//        a.labelView.text = "杨恩涛我问问www我问问呜呜呜呜呜呜呜呜"
////        a.backColor(.green)
//
//        a.imageView.backColor(0x30888888.argb)
//        a.imageView.roundLayer(6)
//        a.labelView.backColor(.cyan)
////        a.labelView.preferredMaxLayoutWidth = 100
//        a.labelView.layout.width(100)
//        a.labelView.numberOfLines = 0

//        self.view.addView(UIScrollView(frame: .zero).backColor(.blue)).apply { sv in
//            sv.layout.fill()
//            sv.addView(LinearLayout(.vertical)).apply { rv in
//                rv.layout.fill().widthOfParent()
//                rv.buildViews {
//                    UILabel.Primary.named("a").text("AAA").align(.center).backColor(.green).linearParams {
//                        $0.width(200).height(200).gravityX(.right)
//                    }
//                    UILabel.Primary.named("b").text("BBB").align(.center).backColor(.cyan).linearParams {
//                        $0.width(200).height(200).gravityX(.fill)
//                    }
//                    UILabel.Primary.named("C").text("CCC").align(.center).backColor(.red).linearParams {
//                        $0.width(200).height(500).gravityX(.left)
//                    }
//                }
//            }
//        }

        self.view.layoutIfNeeded()
//        logd(label.frame)


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        log("DidAppear: ", label.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


