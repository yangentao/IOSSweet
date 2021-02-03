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
        self.view.addView(UIScrollView(frame: .zero).backColor(.blue)).apply { sv in
            sv.layout.fill()
            sv.addView(RelativeLayout(frame: .zero)).apply { rv in
                rv.layout.fill().widthOfParent()
                rv.appendChildren {
                    UILabel.Primary.named("a").text("AAA").align(.center).backColor(.green).relativeParams {
                        $0.widthEQParent().height(900).topParent().leftParent()
                    }
                    UILabel.Primary.named("b").text("BBB").align(.center).backColor(.cyan).relativeParams {
                        $0.widthEQParent().height(900).below("a").leftParent()
                    }
                }
            }
        }


//        self.view.addView(UIScrollView(frame: .zero).backColor(.blue)).apply { sv in
//            sv.layout.fill()
//            sv.addView(UIView(frame: .zero).backColor(.green)).apply { cv in
//                cv.layout {
//                    $0.fill().widthOfParent()
////            $0.heightOfParent(multi: 1.5, constant: 0)
////            $0.height(900)
//                }
//
//                cv.addView(UILabel.Primary.named("a").backColor(.cyan)).apply { lb in
//                    lb.layout.topParent().leftParent().widthOfParent().height(900)
//                    lb.layout.bottomOf(cv)
//                }
//            }
//        }


//        self.view.layoutConstraint {
//            UIScrollView(frame: .zero).backColor(.blue).constraintParams {
//                $0.fill()
//            }.layoutConstraint {
//                RelativeLayout(frame: .zero).named("relView").backColor(.gray).constraintParams {
//                    $0.fill().widthParent()
//                }.appendChildren {
//                    UILabel.Primary.named("a").text("AAA").align(.center).backColor(.green).relativeParams {
//                        $0.centerParent().widthEQParent(multi: 0.8).heightEQSelf(.width)
//                    }
//                    UILabel.Primary.named("b").text("BBB").align(.center).backColor(.blue).relativeParams {
//                        $0.leftEQ("a").below("a", 20).widthEQParent(multi: 0.8).heightEQParent(multi: 0.8)
//                    }
//                    UILabel.Primary.named("c").text("CCC").align(.center).backColor(.cyan).relativeParams {
//                        $0.leftEQ("b").above("a", 20).widthEQParent(multi: 0.8).heightEQParent(multi: 0.8)
//                    }
//                }
//            }
//        }
//
//        view.child(named: "relView", deep: true)?.layout.bottomOf(view.child(named: "c", deep: true)!)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        log(self.view.findByName("relView")?.frame)
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
