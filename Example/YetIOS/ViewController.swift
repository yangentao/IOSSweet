//
//  ViewController.swift
//  YetIOS
//
//  Created by yangentao on 01/02/2021.
//  Copyright (c) 2021 yangentao. All rights reserved.
//

import UIKit

//import IOSSweet


class ViewController: UIViewController {
//    lazy var label: UILabel = NamedView(self, "a")


    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.layoutConstraint {


            RelativeLayout(frame: .zero).paddings(left: 0, top: 25 + 20, right: 0, bottom: 20).constraints {
                $0.fill()
            }.buildChildren {
                UILabel.Primary.text("AAA").align(.center).backColor(.green).relativeConditions {
//                    RC.centerX.eqParent()
                    RC.right.eqParent.constant(-20)
                    RC.width.eqParent.multi(0.5)
                    RC.centerY.eqParent
                    RC.height.eqParent.multi(0.3)
//                    RC(prop: .centerX, relation: .eq, otherViewName: ParentViewName, propOther: .centerX, multiplier: 1, constant: 0)
//                    RC(prop: .width, relation: .eq, otherViewName: ParentViewName, propOther: .width, multiplier: 0.5, constant: 0)
//                    RC(prop: .centerY, relation: .eq, otherViewName: ParentViewName, propOther: .centerY, multiplier: 1, constant: 0)
//                    RC(prop: .height, relation: .eq, otherViewName: ParentViewName, propOther: .height, multiplier: 0.5, constant: 0)
                }
//                UILabel.Primary.text("BBB").align(.center).backColor(.green).marginY(0).linearParams { param in
//                    param.weight(10).widthFill().maxHeight(200).minHeight(60)
//                }
//                UILabel.Primary.text("CCC").align(.right).backColor(.blue).linearParams { param in
//                    param.weight(10).widthFill()
//                }.apply { lb in
//                    lb.clickView { v in
//                        logd("Hello")
//                        self.dialog.showAlert(title: "Title", msg: "Message Is Null")
//                    }
//                }
            }


        }
        self.view.backgroundColor = Colors.background
//        log("LabelText: ", label.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//@propertyWrapper
//public struct View<T> {
//    let key: String
//
//    public init(_ key: String) {
//        self.key = key
//    }
//
//    public var wrappedValue: T {
//        get {
//            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: key)
//        }
//    }
//}
