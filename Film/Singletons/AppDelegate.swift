//
//  AppDelegate.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-22.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        window.rootViewController = initializeViewControllers()
        window.makeKeyAndVisible()
        
        return true
    }

    func initializeViewControllers() -> UIViewController {
        let watchingVC = WatchingViewController()
        let showsVC = ShowsViewController()
        let moviesVC = MoviewsViewController()
        let settingsVC = SettingsViewController()
        
        watchingVC.tabBarItem = UITabBarItem(title: "Watching".localize(), image: ImageConstants.watchingImage, tag: 0)
        showsVC.tabBarItem = UITabBarItem(title: "Shows".localize(), image: ImageConstants.showsImage, tag: 1)
        moviesVC.tabBarItem = UITabBarItem(title: "Movies".localize(), image: ImageConstants.moviesImage, tag: 2)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings".localize(), image: ImageConstants.settingsImage, tag: 3)
        
        let tabViewConroller = UITabBarController()
        tabViewConroller.viewControllers = [watchingVC, showsVC, moviesVC, settingsVC]
        tabViewConroller.tabBar.barTintColor = .black
        
        let navigation = UINavigationController()
        navigation.isNavigationBarHidden = true
        navigation.viewControllers = [tabViewConroller]
        
        return navigation
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

