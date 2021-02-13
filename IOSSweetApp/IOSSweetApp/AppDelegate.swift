//
//  AppDelegate.swift
//  IOSSweetApp
//
//  Created by yangentao on 2021/2/10.
//
//

import UIKit
import IOSSweet

//private var gWindow: UIWindow? = nil
//@discardableResult
//func WindowRootController(_ c: UIViewController) -> UIWindow {
//    if #available(iOS 11.0, *) {
//        UINavigationBar.appearance().prefersLargeTitles = false
//    }
//    let w = UIWindow()
//    w.frame = UIScreen.main.bounds
//    w.rootViewController = c
//    w.makeKeyAndVisible()
//    gWindow = w
//    return w
//}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = WindowRootController(ViewController(nibName: nil, bundle: nil))
        return true
    }
}
