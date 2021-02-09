//
//  AppDelegate.swift
//  IOSSweetApp
//
//  Created by yangentao on 2021/2/10.
//
//

import UIKit

//private var gWindow: UIWindow? = nil
//
//func WindowRootController(_ c: UIViewController) -> UIWindow {
//    if #available(iOS 11.0, *) {
//        UINavigationBar.appearance().prefersLargeTitles = false
//    }
//    let w = UIWindow()
//    gWindow = w
//    w.frame = UIScreen.main.bounds
////    w.backgroundColor = UIColor.white
//    w.rootViewController = c
//    w.makeKeyAndVisible()
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
