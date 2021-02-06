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
//        testSysConstraint()
//        testBuildConstraint()
//        testYetLayout()
//        testGrid()

        testKeyAny()
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

    func testGrid() {
        let gv = Grid(frame: .zero)
        view.addSubview(gv)
        gv.constraintsInstall {
            $0.edgeXParent().edgeYParent(topConst: 25)
        }
        gv.backColor(.blue)
        gv.columns = 2
        let cs: [UIColor] = [.green, .red, .cyan, .yellow]
        gv.setColumnInfo(0, GridColumnInfo(width: 0, weight: 1))
        gv.setRowInfo(0, GridRowInfo(height: 0, weight: 1))
        for i in 0..<4 {
            let lb = UILabel.Primary
            gv.addSubview(lb)
            lb.gridParams {
                $0.width = 100
                $0.height = 50
            }
            lb.text("Text \(i)")
            lb.align(.center)
            lb.backColor(cs[i])
        }
    }

    func testYetLayout() {
        self.view.addView(UILabel.Primary).named("a").text("AAA").backColor(.green).align(.center).lines(0).apply { lb in
            lb.layout {
                $0.centerParent().widthOfParent(multi: 0.8).heightRatio(multi: 0.5)
            }
        }
        self.view.addView(UILabel.Primary).text("BBBBBB").backColor(.cyan).align(.center).apply { lb in
            lb.layout { b in
                b.centerX.eq("a")
                b.width.eq("a")
                b.top.eq("a", .bottom)
                b.height.eq("a")
            }
        }
    }

    func testBuildConstraint() {
        view.buildViews {
            UILabel.Primary.text("AAA").align(.center).named("a").backColor(.green).constraints {
                $0.centerParent().widthParent(multi: 0.8).heightRatio(multi: 0.6)
            }
            UILabel.Primary.text("BBB").align(.center).named("b").backColor(.cyan).apply { lb in
                lb.constraints { b in
                    b.left.eq("a")
                    b.top.eq("a", otherAttr: .bottom)
                    b.size.eq("a")
                }
            }
        }

    }

    func testSysConstraint() {
        self.view.addView(UILabel.Primary).named("a").text("AAA").backColor(.green).align(.center).lines(0).apply { lb in
            lb.constraintsInstall {
                $0.centerParent().widthParent(multi: 0.8).heightRatio(multi: 0.5).ident("heightId")
            }
        }
        self.view.addView(UILabel.Primary).text("BBBBBB").backColor(.cyan).align(.center).apply { lb in
            lb.constraintsInstall { b in
                b.centerX.eq("a")
                b.width.eq("a")
                b.top.eq("a", otherAttr: .bottom)
                b.height.eq("a")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        logd("DidAppear: ", label.frame)
//        Log.debug("DidAppear: ", label.frame)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


