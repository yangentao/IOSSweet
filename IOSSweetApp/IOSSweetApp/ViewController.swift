//
//  ViewController.swift
//  IOSSweetApp
//
//  Created by yangentao on 2021/2/10.
//
//

import UIKit
import SwiftSweet
import IOSSweet

extension MsgID {
    static let labelTextChanged = MsgID("label.text.changed")
}

class ViewController: UIViewController {
    lazy var label: UILabel = UILabel(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view += label.apply { lb in
            lb.constraints { c in
                c.centerParent()
                c.width(200)
                c.height(80)
            }
            lb.named("label")
            lb.backgroundColor = .green
            lb.text = "Hello"
            lb.textColor = .red
            lb.textAlignment = .center
        }


        label.clickView { v in
            self.toast.show("Hello \(IDGen()) ")
        }

        let p = GridPage<String> (nibName: nil, bundle: nil)


    }


}
