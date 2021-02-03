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
            sv.addView(LinearLayout(.vertical)).apply { rv in
                rv.layout.fill().widthOfParent()
                rv.buildViews {
                    UILabel.Primary.named("a").text("AAA").align(.center).backColor(.green).linearParams {
                        $0.width(200).height(200).gravityX(.right)
                    }
                    UILabel.Primary.named("b").text("BBB").align(.center).backColor(.cyan).linearParams {
                        $0.width(200).height(200).gravityX(.fill)
                    }
                    UILabel.Primary.named("C").text("CCC").align(.center).backColor(.red).linearParams {
                        $0.width(200).height(500).gravityX(.left)
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


