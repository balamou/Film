//
//  MovieInfoViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-15.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol MovieInfoViewControllerDelegate: class {
    func playMovie()
}

class MovieInfoViewController: UIViewController {
    weak var delegate: MovieInfoViewControllerDelegate?
    var movieInfoView = MovieInfoView()
    
    var movie: Movie?
    var apiManager: MovieInfoAPI?
    
    let maximumDescriptionCharacters = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = movieInfoView
        movieInfoView.delegate = self
        
        initialMovieInfoLoading()
    }
    
    func populateData(movie: Movie) {
        movieInfoView.titleLabel.text = movie.title
        movieInfoView.descriptionLabel.text = movie.description?.truncate(maximumDescriptionCharacters) ?? ""
        
        if let url = movie.poster {
            movieInfoView.posterPicture.downloaded(from: url)
        }
        
        if let _ = movie.stoppedAt {
            movieInfoView.changeStoppedAtMultiplier(movie.stoppedAtRatio())
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


//----------------------------------------------------------------------
// MARK: API call
//----------------------------------------------------------------------
extension MovieInfoViewController {
    
    func initialMovieInfoLoading() {
        apiManager?.getMovieInfo(movieId: 0) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movie):
                self.movie = movie
                self.populateData(movie: movie)
            case .failure(_):
                self.navigationController?.popViewController(animated: false)
                // TODO: Show error in previous VC
            }
            
        }
    }
}


extension MovieInfoViewController: MovieViewDelegate {
    
    func playButtonTapped() {
        delegate?.playMovie()
    }
    
    func exitButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
}
