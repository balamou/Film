//
//  Coordinator.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class Coordinator {
    
    let window: UIWindow
    
    let navigationController = UINavigationController()
    let tabViewConroller = UITabBarController()
    
    var playerVC: VideoPlayerController?
    let factory: ViewControllerFactory = StandardFactory()
    let settings: Settings = Settings()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() -> UIViewController {
        guard settings.isLogged else {
            return loginFlow()
        }
        
        return mainFlow()
    }
    
    func loginFlow() -> UIViewController {
        let welcomeVC = factory.createWelcomeViewController(delegate: self, settings: settings)
        
        print(settings.description())
        return welcomeVC
    }
    
    func mainFlow() -> UIViewController {
        let watchingVC = factory.createWatchingViewController(delegate: self)
        let showsVC = factory.createShowViewController(delegate: self)
        let moviesVC = factory.createMoviesViewController(delegate: self)
        let settingsVC = factory.createSettingsViewController(delegate: self, settings: settings)
        
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

extension Coordinator: WelcomeViewControllerDelegate {
    
    func onSuccessfullLogin() {
        window.rootViewController = mainFlow()
    }
    
}

extension Coordinator: SettingsViewControllerDelegate {
    
    func logOutPerformed() {
        window.rootViewController = loginFlow()
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
            let showInfoVC = factory.createShowInfoViewController(delegate: self, series: SeriesPresenter(watched))
            navigationController.pushViewController(showInfoVC, animated: false)
        }
    }
}

extension Coordinator: ShowsDelegate {
    
    func tappedOnSeriesPoster(series: SeriesPresenter) {
        let showInfoVC = factory.createShowInfoViewController(delegate: self, series: series)
        
        navigationController.pushViewController(showInfoVC, animated: false)
    }
    
}

extension Coordinator: MoviesDelegate {
    
    func tappedOnMoviesPoster(movie: MoviesPresenter) {
        let movieInfoVS = factory.createMovieInfoViewController(delegate: self, movie: movie)
        
        navigationController.pushViewController(movieInfoVS, animated: false)
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

extension Coordinator: MovieInfoViewControllerDelegate {
    
    func playMovie() {
        // TODO: launch player
    }
}
