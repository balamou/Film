//
//  Coordinator.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class Coordinator {
    
    let navigationController = UINavigationController()
    var playerVC: VideoPlayerController?
    
    func start() -> UIViewController {
        let watchingVC = WatchingViewController()
        let showsVC = ShowsViewController()
        let moviesVC = MoviewsViewController()
        let settingsVC = SettingsViewController()
        
        watchingVC.tabBarItem = UITabBarItem(title: "Watching".localize(), image: ImageConstants.watchingImage, tag: 0)
        showsVC.tabBarItem = UITabBarItem(title: "Shows".localize(), image: ImageConstants.showsImage, tag: 1)
        moviesVC.tabBarItem = UITabBarItem(title: "Movies".localize(), image: ImageConstants.moviesImage, tag: 2)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings".localize(), image: ImageConstants.settingsImage, tag: 3)
        
        watchingVC.delegate = self
        
        let tabViewConroller = UITabBarController()
        tabViewConroller.viewControllers = [watchingVC, showsVC, moviesVC, settingsVC]
        tabViewConroller.tabBar.barTintColor = .black
        
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [tabViewConroller]
        
        return navigationController
    }
    
    
    func applicationDidBecomeActive() {
        playerVC?.applicationDidBecomeActive()
    }
    
    func applicationWillResignActive() {
        playerVC?.applicationWillResignActive()
    }
}

extension Coordinator: WatchingViewControllerDelegate {
    
    func tappedPreviouslyWatchedShow() {
        let playerVC = VideoPlayerController()
        self.playerVC = playerVC
        navigationController.pushViewController(playerVC, animated: false)
    }
    
}
