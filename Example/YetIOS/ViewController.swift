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
    lazy var label: UILabel = NamedView(self, "a")


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addView(UIScrollView(frame: .zero).backColor(.blue)).apply { sv in
            sv.layout.fill()
            sv.addView(RelativeLayout(frame: .zero)).apply { rv in
                rv.layout.fill().widthOfParent()
                rv.buildViews {
                    UILabel.Primary.named("a").text("AAA").align(.center).backColor(.green).relativeParams {
                        $0.widthEQParent().height(900).topParent().leftParent()
                    }
                    UILabel.Primary.named("b").text("BBB").align(.center).backColor(.cyan).relativeParams {
                        $0.widthEQParent().height(900).below("a").leftParent()
                    }
                }
            }
        }


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        log(label.frame)
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
