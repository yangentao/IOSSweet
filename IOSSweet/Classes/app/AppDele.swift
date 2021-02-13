//
//  AppDelegate.swift
//  Hare
//
//  Created by yangentao on 2017/10/7.
//  Copyright © 2017年 yet.net. All rights reserved.
//

import UIKit

open class AppDele: UIResponder, UIApplicationDelegate {

	public var window: UIWindow?

	open func onRootController(_ w: UIWindow) -> UIViewController {
		return UIViewController(nibName: nil, bundle: nil)
	}

	open func onConfig(){

	}

	open func onConfigGlobalStyle() {
		UIBarButtonItem.appearance().setTitleTextAttributes([
			NSAttributedString.Key.foregroundColor: Color.white,
			NSAttributedString.Key.font: Fonts.regular(14)
		], for: UIControl.State.normal)

		UIBarButtonItem.appearance().setTitleTextAttributes([
			NSAttributedString.Key.foregroundColor: Color.red,
			NSAttributedString.Key.font: Fonts.regular(14)
		], for: UIControl.State.highlighted)

		UITabBarItem.appearance().setTitleTextAttributes([
			NSAttributedString.Key.foregroundColor: Theme.Text.minorColor,
			NSAttributedString.Key.font: Fonts.regular(10)
		], for: UIControl.State.normal)

		UITabBarItem.appearance().setTitleTextAttributes([
			NSAttributedString.Key.foregroundColor: Theme.themeColor,
			NSAttributedString.Key.font: Fonts.regular(10)
		], for: UIControl.State.selected)

		UITabBar.appearance().barTintColor = Theme.TabBar.backgroundColor
		UITabBar.appearance().tintColor = Theme.TabBar.lightColor
		if #available(iOS 10, *) {
			UITabBar.appearance().unselectedItemTintColor = Theme.TabBar.grayColor
		}

		let navAppear = UINavigationBar.appearance()
		navAppear.barTintColor = Theme.TitleBar.backgroundColor
		navAppear.tintColor = Theme.TitleBar.textColor
		navAppear.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: Theme.TitleBar.textColor
		]
		navAppear.shadowImage = UIImage()

	}

	open func onLaunch() {

	}

	open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if #available(iOS 11.0, *) {
			UINavigationBar.appearance().prefersLargeTitles = false
		}
		let w = UIWindow()
		self.window = w
		w.frame = UIScreen.main.bounds
		w.backgroundColor = UIColor.white
		self.onConfig()
		self.onConfigGlobalStyle()
		w.rootViewController = onRootController(w)
		w.makeKeyAndVisible()
		onLaunch()
		return true
	}

	open func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	open func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	open func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	open func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	open func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

