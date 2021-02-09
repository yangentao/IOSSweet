//
//  ViewController.swift
//  IOSSweetApp
//
//  Created by yangentao on 2021/2/10.
//
//

import UIKit
import SwiftSweet


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view += UILabel(frame: .zero).apply { lb in
            lb.constraints { c in
                c.centerParent()
                c.width(200)
                c.height(80)
            }
            lb.backgroundColor = .green
            lb.text = "Hello"
            lb.textColor = .red
            lb.textAlignment = .center
        }

    }


}
