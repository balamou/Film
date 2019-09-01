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
    let builder: Builder = StandardBuilder()
    
    func start() -> UIViewController {
        
        // Setup ViewController
        let watchingVC = builder.createWatchingViewController(delegate: self)
        let showsVC = builder.createShowViewController(delegate: self)
        let moviesVC = builder.createMoviesViewController()
        let settingsVC = builder.createSettingsViewController()
        
        // Setup Navigation
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
    
    func playTapped() {
        let playerVC = VideoPlayerController()
        self.playerVC = playerVC
        navigationController.pushViewController(playerVC, animated: false)
    }
    
    func moreInfoTapped() {
        // TODO: open ShowInfoVC or MovieInfoVC
        print("## Open info")
    }
}

extension Coordinator: ShowsDelegate {
    
    func tappedOnSeriesPoster(series: SeriesPresenter) {
        let showInfoVC = builder.createShowInfoViewController(delegate: self, series: series)
        
        navigationController.pushViewController(showInfoVC, animated: false)
    }
    
}

extension Coordinator: ShowInfoViewControllerDelegate {
    
    func exitButtonTapped() {
        navigationController.popViewController(animated: false)
    }
    
    func playButtonTapped() {
        print("play last episode")
    }
    
    func thumbnailTapped() {
        print("play episode")
    }
    
}
