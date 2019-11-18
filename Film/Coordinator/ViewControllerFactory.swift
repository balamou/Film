//
//  ViewControllerFactory.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ViewControllerFactory {
    func createWelcomeViewController(delegate: WelcomeViewControllerDelegate?, settings: Settings) -> WelcomeViewController
    
    func createWatchingViewController(delegate: WatchingViewControllerDelegate?, settings: Settings) -> WatchingViewController
    func createShowViewController(delegate: ShowsDelegate?, settings: Settings) -> ShowsViewController
    func createMoviesViewController(delegate: MoviesDelegate?, settings: Settings) -> MoviesViewController
    func createSettingsViewController(delegate: SettingsViewControllerDelegate?, settings: Settings) -> SettingsViewController
    
    func createShowInfoViewController(delegate: ShowInfoViewControllerDelegate?, series: SeriesPresenter) -> ShowInfoViewController
    func createMovieInfoViewController(delegate: MovieInfoViewControllerDelegate?, movie: MoviesPresenter) -> MovieInfoViewController
}


class StandardFactory: ViewControllerFactory {
    
    func createWelcomeViewController(delegate: WelcomeViewControllerDelegate?, settings: Settings) -> WelcomeViewController {
        let welcomeVC = WelcomeViewController(settings: settings)
        welcomeVC.delegate = delegate
        welcomeVC.apiManager = ConcreteWelcomeAPI(settings: settings)
        
        return welcomeVC
    }
    
    func createWatchingViewController(delegate: WatchingViewControllerDelegate?, settings: Settings) -> WatchingViewController {
        let watchingVC = WatchingViewController()
        watchingVC.delegate = delegate
        watchingVC.apiManager = ConcreteWatchedAPI(settings: settings)
        watchingVC.tabBarItem = UITabBarItem(title: "Watching".localize(), image: Images.watchingImage, tag: 0)
        
        return watchingVC
    }
    
    func createShowViewController(delegate: ShowsDelegate?, settings: Settings) -> ShowsViewController {
        let showsVC = ShowsViewController()
        let apiManager: SeriesAPI = ConcreteSeriesAPI(settings: settings)
        
        showsVC.apiManager = apiManager
        showsVC.delegate = delegate
        showsVC.tabBarItem = UITabBarItem(title: "Shows".localize(), image: Images.showsImage, tag: 1)
        
        return showsVC
    }
    
    func createMoviesViewController(delegate: MoviesDelegate?, settings: Settings) -> MoviesViewController {
        let moviesVC = MoviesViewController()
        let apiManager: MoviesAPI = ConcreteMoviesAPI(settings: settings)
        
        moviesVC.apiManager = apiManager
        moviesVC.delegate = delegate
        moviesVC.tabBarItem = UITabBarItem(title: "Movies".localize(), image: Images.moviesImage, tag: 2)
       
        return moviesVC
    }
    
    func createSettingsViewController(delegate: SettingsViewControllerDelegate?, settings: Settings) -> SettingsViewController {
        let settingsVC = SettingsViewController(settings: settings)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings".localize(), image: Images.settingsImage, tag: 3)
        settingsVC.delegate = delegate
        
        return settingsVC
    }
    
    func createShowInfoViewController(delegate: ShowInfoViewControllerDelegate?, series: SeriesPresenter) -> ShowInfoViewController {
        let apiManager = MockSeriesInfoAPI()
        let showInfoVC = ShowInfoViewController(seriesPresenter: series)
        showInfoVC.delegate = delegate
        showInfoVC.apiManager = apiManager
        
        return showInfoVC
    }
    
    func createMovieInfoViewController(delegate: MovieInfoViewControllerDelegate?, movie: MoviesPresenter) -> MovieInfoViewController {
        // TODO: pass movie to MovieInfo
        let apiManager = MockMovieInfoAPI()
        let movieInfoVC = MovieInfoViewController()
        movieInfoVC.delegate = delegate
        movieInfoVC.apiManager = apiManager
        
        return movieInfoVC
    }
}
