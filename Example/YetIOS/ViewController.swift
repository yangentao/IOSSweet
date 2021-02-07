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
//        testButton()
        testJson()

    }

    func testJson() {
        let a = yson {
            "name" >> "Entao"
            "addr" >> {
                "prov" >> "ShanDong"
                "city" >> "JiNan"
            }
            "age" >> 99
            "Children" >> [1, "a", nil, [2, "b", nil, yson {
                "dev" >> ["mac", "android"]
            }]]
        }
        logd(a)
        let b = ysonArray([
            [1, "a", nil,
             [2, "b", nil,
              yson {
                  "dev" >> ["mac", "android"]
              }
             ]
            ]
        ])
        logd(b)
    }


    func testButton() {
        view += UIButton.Default.title("Hello").backColor(.green).textColorPrimary().constraints {
            $0.centerParent().width(100).height(50)
        }.click { [weak self] b in
            self?.testDialog()
        }

        view.layoutIfNeeded()
    }

    func testDialog() {
        let p = DialogX(self)
        p.title("Hello Title")
        p.button(.cancel, "Cancel") {
            logd("Cancel Click")
        }
        p.button(.ok, "OK") {
            logd("OK Click")
        }
        p.message("多发发额外染发膏温柔发噶释放大二噶说过梵蒂冈电视功夫大师问他")
        p.show()
    }

    func testLinearVer() {
        view += LinearLayout(.horizontal).backColor(.gray).apply { ll in
            ll += UILabel.Primary.text("AAA").backColor(.green).align(.center).linearParams { p in
                p.width(100).height(50).weight(0)
                p.margins.hor(20).ver(10)
                p.gravityX = .center
                p.gravityY = .center
            }
            ll += UILabel.Primary.text("BBB").backColor(.red).align(.center).linearParams { p in
                p.width(100).height(50).weight(0)
                p.margins.hor(10).ver(20)
                p.gravityX = .fill
                p.gravityY = .fill
            }
        }.constraints { c in
            c.centerParent().widthParent(constant: -40).heightRatio(multi: 1)
        }
    }

    func testLinearHor() {
        view += LinearLayout(.horizontal).backColor(.gray).apply { ll in
            ll += UILabel.Primary.text("AAA").backColor(.green).align(.center).linearParams { p in
                p.height(MatchParent).weight(1).width(40)
            }
            ll += UILabel.Primary.text("BBB").backColor(.red).align(.center).linearParams { p in
                p.height(MatchParent).weight(1).width(40)
            }
        }.constraints { c in
            c.centerParent().widthParent(constant: -40).heightRatio(multi: 1)
        }
    }

    func testLinear() {

        view += LinearLayout(.horizontal).apply { ll in
            ll.constraints {
                $0.centerParent().widthParent(constant: -20).heightRatio(multi: 1)
            }
            ll.backColor(.green)
            ll += UIButton.Default.title("Hello").titleColor(Theme.dangerColor).linearParams(0, MatchParent) {
                $0.weight = 1
            }
            ll += UIButton.Default.title("Entao").titleColor(Theme.accent).linearParams(0, MatchParent) {
                $0.weight = 1
            }
        }
    }

    func testGrid() {
        let gv = GridLayout(frame: .zero)
        view += gv
        gv.constraintsInstall {
            $0.centerParent().widthParent().heightRatio(multi: 1)
        }
        gv.backColor(.gray)
        gv.columns = 3
        gv.setColumnInfoDefault(value: 0, weight: 1)
        gv.setRowInfoDefault(value: 0, weight: 1)

        gv += makeLabel(0) { p in
            p.rowSpan = 2
            p.columnSpan = 1
        }
        gv += makeLabel(1) { p in
            p.rowSpan = 1
            p.columnSpan = 2
        }
        gv += makeLabel(2) { p in
            p.width = 50
            p.height = 50
            p.gravityX = .fill
            p.gravityY = .center
            p.margins.hor(20)
            p.rowSpan = 1
            p.columnSpan = 1
        }
        gv += makeLabel(3) { p in
            p.rowSpan = 2
            p.columnSpan = 1
        }
        gv += makeLabel(4) { p in
            p.rowSpan = 1
            p.columnSpan = 2
        }
        view.layoutIfNeeded()
        logd(gv.contentSize)
    }

    func makeLabel(_ i: Int, _ block: (GridParams) -> Void) -> UILabel {
        let cs: [UIColor] = [.green, .red, .cyan, .yellow, .blue, .gray]
        let lb = UILabel.Primary
        lb.tagS = "Label:\(i)"
        lb.text("Text \(i)")
        lb.align(.center)
        lb.backColor(cs[i])
        block(lb.gridParamsEnsure)
        return lb
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
        view ++= {
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


