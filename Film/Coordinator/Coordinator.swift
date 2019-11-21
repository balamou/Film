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
        
        print(settings)
        return welcomeVC
    }
    
    func mainFlow() -> UIViewController {
        let watchingVC = factory.createWatchingViewController(delegate: self, settings: settings)
        let showsVC = factory.createShowViewController(delegate: self, settings: settings)
        let moviesVC = factory.createMoviesViewController(delegate: self, settings: settings)
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
    
    func welcomeViewControllerSuccessfullLogin(_ welcomeViewController: WelcomeViewController) {
        window.rootViewController = mainFlow()
    }
    
}

extension Coordinator: SettingsViewControllerDelegate {
    
    func settingsViewControllerLogout(_ settingsViewController: SettingsViewController) {
        window.rootViewController = loginFlow()
    }
}

extension Coordinator: WatchingViewControllerDelegate {
    
    func watchingViewController(_ watchingViewController: WatchingViewController, play watched: Watched) {
        let playerVC = factory.createVideoPlayerController(film: Film.from(watched: watched))
        self.playerVC = playerVC
        
        navigationController.pushViewController(playerVC, animated: false)
    }
    
    func watchingViewController(_ watchingViewController: WatchingViewController, selectMoreInfo watched: Watched) {
        switch watched.type {
        case .movie:
            let movie = Movie(id: watched.id, title: watched.title ?? "", duration: 1, videoURL: watched.movieURL, poster: watched.posterURL, stoppedAt: watched.stoppedAt)
            
            let movieInfoVC = factory.createMovieInfoViewController(delegate: self, movie: movie, settings: settings)
            navigationController.pushViewController(movieInfoVC, animated: false)
        case .show:
            guard let showId = watched.showId else { return }
            let series = Series(id: showId, title: watched.title ?? "", seasonSelected: 1, totalSeasons: 0, posterURL: watched.posterURL)
            
            let showInfoVC = factory.createShowInfoViewController(delegate: self, series: series, settings: settings)
            navigationController.pushViewController(showInfoVC, animated: false)
        }
    }
}

extension Coordinator: ShowsDelegate {
    
    func showsViewController(_ showsViewController: ShowsViewController, selected seriesItem: SeriesItem) {
        let series = Series(id: seriesItem.id, title: "", seasonSelected: 1, totalSeasons: 0, posterURL: seriesItem.posterURL)
        let showInfoVC =  factory.createShowInfoViewController(delegate: self, series: series, settings: settings)
        
        navigationController.pushViewController(showInfoVC, animated: false)
    }
    
}

extension Coordinator: MoviesDelegate {
    
    func moviesViewController(_ moviesViewController: MoviesViewController, selected moviePresenter: MoviesPresenter) {
        let movie = Movie(id: moviePresenter.id, title: "", duration: 100, videoURL: "", poster: moviePresenter.posterURL)
        let movieInfoVC = factory.createMovieInfoViewController(delegate: self, movie: movie, settings: settings)
        
        navigationController.pushViewController(movieInfoVC, animated: false)
    }
    
}

extension Coordinator: ShowInfoViewControllerDelegate {
    
    func showInfoViewControllerDidExit(_ showInfoViewController: ShowInfoViewController) {
        navigationController.popViewController(animated: false)
    }
    
    func showInfoViewControllerPlayShow(_ showInfoViewController: ShowInfoViewController) {
        print("play last episode")
    }
    
    func showInfoViewController(_ showInfoViewController: ShowInfoViewController, play episode: Episode) {
        let playerVC = factory.createVideoPlayerController(film: Film.from(episode: episode))
        self.playerVC = playerVC
        
        navigationController.pushViewController(playerVC, animated: false)
    }
    
    func showInfoViewController(_ showInfoViewController: ShowInfoViewController, exitWith error: Error) {
        navigationController.popViewController(animated: false)
        
        guard let shownVC = tabViewConroller.selectedViewController else { return }
        
        if let watchingViewController = shownVC as? WatchingViewController {
            watchingViewController.alert?.mode = .showMessage(error.toString)
        }
        
        if let showViewController = shownVC as? ShowsViewController {
            showViewController.alert?.mode = .showMessage(error.toString)
        }
    }
    
}

extension Coordinator: MovieInfoViewControllerDelegate {
    
    func movieInfoViewController(_ movieInfoViewController: MovieInfoViewController, play movie: Movie) {
        let playerVC = factory.createVideoPlayerController(film: Film.from(movie: movie))
        self.playerVC = playerVC
        
        navigationController.pushViewController(playerVC, animated: false)
    }
}
