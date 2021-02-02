//
//  ViewController.swift
//  YetIOS
//
//  Created by yangentao on 01/02/2021.
//  Copyright (c) 2021 yangentao. All rights reserved.
//

import UIKit
import IOSSweet


class ViewController: UIViewController {
//    lazy var label: UILabel = NamedView(self, "a")

    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.layoutConstraint {

            VerticalLinear.paddings(left: 20, top: 25 + 20, right: 20, bottom: 20).constraints {
                $0.fill()
            }.buildChildren {
                UILabel.Primary.text("AAA").align(.left).backColor(.cyan).linearParam { param in
                    param.widthFill().weight(1) //.height(60)
                }
                UILabel.Primary.text("BBB").align(.center).backColor(.green).marginY(20).linearParam { param in
                    param.widthFill().height(60)
                }
                UILabel.Primary.text("CCC").align(.right).backColor(.blue).linearParam { param in
                    param.widthFill().weight(2)//.height(60)
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
