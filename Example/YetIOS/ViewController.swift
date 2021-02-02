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


            RelativeLayout(frame: .zero).constraints {
                $0.fill()
            }.buildChildren {
                UILabel.Primary.named("a").text("AAA").align(.center).backColor(.green).relativeConditions {
                    RC.centerX.eqParent
                    RC.centerY.eqParent
                    RC.width.eqParent.multi(0.5)
                    RC.height.eqParent.multi(0.3)
                }
                UILabel.Primary.named("b").text("BBB").align(.center).backColor(.blue).relativeConditions {
                    RC.left.eq("a")
                    RC.top.eq("a", .bottom).constant(20)
                    RC.width.eqParent.multi(0.5)
                    RC.height.eqParent.multi(0.3)
                }
                UILabel.Primary.named("c").text("CCC").align(.center).backColor(.cyan).relativeConditions {
                    RC.left.eq("b")
                    RC.bottom.eq("a", .top).constant(20)
                    [RC.width.eqParent.multi(0.5),
                     RC.height.eqParent.multi(0.3)]
                }
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
