//
//  MovieInfoViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-15.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol MovieInfoViewControllerDelegate: class {
    func movieInfoViewController(_ movieInfoViewController: MovieInfoViewController, play movie: Movie)
}

class MovieInfoViewController: UIViewController {
    weak var delegate: MovieInfoViewControllerDelegate?
    private var movieInfoView = MovieInfoView()
    
    private var movie: Movie
    var apiManager: MovieInfoAPI?
    
    private let maximumDescriptionCharacters = 180
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            movieInfoView.posterPicture.loadImage(fromURL: url)
        }
        
        if let _ = movie.stoppedAt {
            movieInfoView.changeStoppedAtMultiplier(movie.percentViewed)
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
        apiManager?.getMovieInfo(movieId: movie.id) { [weak self] result in
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
        delegate?.movieInfoViewController(self, play: movie)
    }
    
    func exitButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
}
