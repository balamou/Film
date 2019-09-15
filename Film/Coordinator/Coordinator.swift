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
    let tabViewConroller = UITabBarController()
    
    var playerVC: VideoPlayerController?
    let builder: Builder = StandardBuilder()
    
    func start() -> UIViewController {
        
        // Setup ViewController
        let watchingVC = builder.createWatchingViewController(delegate: self)
        let showsVC = builder.createShowViewController(delegate: self)
        let moviesVC = builder.createMoviesViewController(delegate: self)
        let settingsVC = builder.createSettingsViewController()
        
        // Setup Navigation
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
    
    func playTapped(watched: Watched) {
        let playerVC = VideoPlayerController()
        self.playerVC = playerVC
        navigationController.pushViewController(playerVC, animated: false)
    }
    
    func moreInfoTapped(watched: Watched) {
        switch watched.type {
        case .movie:
             // TODO: open MovieInfoVC
            break
        case .show:
            let showInfoVC = builder.createShowInfoViewController(delegate: self, series: SeriesPresenter(watched))
            navigationController.pushViewController(showInfoVC, animated: false)
        }
    }
}

extension Coordinator: ShowsDelegate {
    
    func tappedOnSeriesPoster(series: SeriesPresenter) {
        let showInfoVC = builder.createShowInfoViewController(delegate: self, series: series)
        
        navigationController.pushViewController(showInfoVC, animated: false)
    }
    
}

extension Coordinator: MoviesDelegate {
    
    func tappedOnMoviesPoster(movie: MoviesPresenter) {
        // TODO: Open MoviesInfoVC
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
    
    func exitWithError(error: Error) {
        navigationController.popViewController(animated: false)
        
        guard let shownVC = tabViewConroller.selectedViewController else { return }
        
        if let watchingViewController = shownVC as? WatchingViewController {
            watchingViewController.alert?.mode = .showMessage(error.localizedDescription)
        }
        
        if let showViewController = shownVC as? ShowsViewController {
            showViewController.alert?.mode = .showMessage(error.localizedDescription)
        }
    }
    
}
