//
//  MoviesViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol MoviesDelegate: class {
    func moviesViewController(_ moviesViewController: MoviesViewController, selected movie: MoviesPresenter)
}

enum MoviesViewControllerState {
    case loading
    case idle
    case hasData([MoviesPresenter], isLast: Bool)
}

class MoviesViewController: UIViewController {
    
    weak var delegate: MoviesDelegate?
    var apiManager: MoviesAPI?
    var alert: AlertViewController?
    
    private var moviesView: MoviesView = MoviesView()
    private var data = [MoviesPresenter]()
    
    private var state: MoviesViewControllerState = .loading {
        didSet { switchState(state) }
    }
    
    // Params
    private let numberOfMoviesToLoad = 9
    private var isInfiniteScrollEnabled: Bool = true
    private var isFetchingMore: Bool = false
    
    // Collection view
    private var collectionView: UICollectionView!
    
    // Sections
    private var sections: [Section] = []
    private var dataSection: Section!
    private var idleSection: Section!
    private var loadingSection: Section!
    private var loadingMoreSection: Section!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = moviesView
        
        alert = AlertViewController(parent: self)
        
        initializeSections()
        addCollectionView()
        initialLoadMovies()
        
        state = .loading
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //----------------------------------------------------------------------
    // MARK: Sections
    //----------------------------------------------------------------------
    func initializeSections() {
        idleSection = Section(cellType: IdleCell.self, identifier: IdleCell.identifier)
        dataSection = Section(cellType: MovieCell.self, identifier: MovieCell.identifier)
        loadingSection = Section(cellType: LoadingWaitCell.self, identifier: LoadingWaitCell.identifier)
        loadingMoreSection = Section(cellType: LoadingCell.self, identifier: LoadingCell.identifier)
        loadingSection.show()
        
        sections = [idleSection, dataSection, loadingSection, loadingMoreSection]
        
        configureSections()
    }
    
    func configureSections() {
        dataSection.cellStyle = CellStyle(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), columnDistance: 10.0, rowDistance: 20.0)
        loadingMoreSection.cellStyle = CellStyle(insets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0), columnDistance: 0, rowDistance: 0)
        
        dataSection.cellStyle.size = { width, _ -> CGSize in MovieCell.calculateCellSize(collectionViewWidth: width) }
        loadingMoreSection.cellStyle.size = { (width, _) -> CGSize in CGSize(width: width, height: 50) }
        
        loadingMoreSection.populateCell = { cell, row in
            let loadingMoreCell = cell as! LoadingCell
            loadingMoreCell.spinner.startAnimating()
        }
        
        dataSection.populateCell = { [weak self] cell, row in
            guard let self = self else { return }
            guard self.data.count > row else { return }
            
            let movieCell = cell as! MovieCell
            movieCell.posterURL = self.data[row].posterURL
        }
        
        dataSection.selectedCell = { [weak self] row in
            guard let self = self else { return }
            
            self.delegate?.moviesViewController(self, selected: self.data[row])
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Collection View
    //----------------------------------------------------------------------
    func addCollectionView() {
        let collectionVC = AbstractedCollectionViewController(sections: sections)
        collectionVC.scrollingDelegate = self
        addChildViewController(child: collectionVC)
        
        collectionVC.addPullOnRefresh(for: { [weak self] in
            self?.refreshOnPull()
        })
        
        // Setup collection view
        collectionView = collectionVC.collectionView
        
        [collectionView.topAnchor.constraint(equalTo: moviesView.navBar.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].activate()
    }
}

//----------------------------------------------------------------------
// MARK: State machine
//----------------------------------------------------------------------
extension MoviesViewController {
    
    func switchState(_ newState: MoviesViewControllerState) {
        collectionView.alwaysBounceVertical = true
        sections.forEach { $0.hide() }
        isInfiniteScrollEnabled = false
        data = []
        
        switch newState {
        case .loading:
            loadingSection.show()
            collectionView.alwaysBounceVertical = false // do not bounce when loading
        case .idle:
            idleSection.show()
        case .hasData(let movies, isLast: let isLast):
            dataSection.show()
            
            data = movies
            dataSection.numberOfItems = data.count
            isInfiniteScrollEnabled = !isLast // maybe
        }
        
        collectionView.reloadData()
    }
    
}

//----------------------------------------------------------------------
// Scrolling: "Infinite Scroll"
//----------------------------------------------------------------------
extension MoviesViewController: ScrollingDelegate {
    
    func batchFetch() {
        if !isFetchingMore && isInfiniteScrollEnabled {
            loadingMoreSection.show()
            collectionView.reloadSections(IndexSet(integer: 3))
            isFetchingMore = true
            
            loadMoreOnDragDown()
        }
    }
}

//----------------------------------------------------------------------
// MARK: API Calls
//----------------------------------------------------------------------
extension MoviesViewController {
    
    func initialLoadMovies() {
        apiManager?.getMovies(start: 0, quantity: numberOfMoviesToLoad) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let movies, let isLast)):
                self.state = movies.isEmpty ? .idle : .hasData(movies, isLast: isLast)
                
            case .failure(let error):
                self.alert?.mode = .showMessage(error.localizedDescription)
                self.state = .idle
            }
        }
    }
    
    func loadMoreOnDragDown() {
        apiManager?.getMovies(start: data.count, quantity: numberOfMoviesToLoad) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success((let movies, let isLast)):
                let appendNewData = self.data + movies
                self.state = appendNewData.isEmpty ? .idle : .hasData(appendNewData, isLast: isLast)
                
            case .failure(let error):
                self.alert?.mode = .showMessage(error.localizedDescription)
                self.loadingMoreSection.hide()
                self.collectionView.reloadSections(IndexSet(integer: 3)) // refresh the section with the spinner
            }
            
            self.isFetchingMore = false
        }
    }
    
    func refreshOnPull() {
        apiManager?.getMovies(start: 0, quantity: numberOfMoviesToLoad) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success((let movies, let isLast)):
                self.state = movies.isEmpty ? .idle : .hasData(movies, isLast: isLast)
                
            case .failure(let error):
                self.alert?.mode = .showMessage(error.localizedDescription)
            }
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
}


