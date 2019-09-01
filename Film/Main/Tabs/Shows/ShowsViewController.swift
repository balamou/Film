//
//  ShowsViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ShowsDelegate: AnyObject {
    func tappedOnSeriesPoster(series: SeriesPresenter) // tapped on poster to get more information
}

enum ShowsViewControllerMode {
    case loading
    case hasShows([SeriesPresenter], isLast: Bool)
}

class ShowsViewController: UIViewController {
    
    var showsView: ShowsView!
    weak var showsCollectionView: UICollectionView!
    weak var delegate: ShowsDelegate?
    
    var isFetchingMore = false
    var isInfiniteScrollEnabled = true
    var data: [SeriesPresenter] = []
    var mode: ShowsViewControllerMode = .loading {
        didSet {
            switchedMode(mode: mode)
        }
    }
    // API
    var apiManager: SeriesAPI?
    let numberOfShowsToLoad = 9
    
    // Alert
    var alert: AlertViewController?
    
    //----------------------------------------------------------------------
    // MARK: Methods
    //----------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showsView = ShowsView()
        view = showsView
        showsView.delegate = self
        alert = AlertViewController(parent: self)
        
        setupCollectionView()
        initialLoadSeries()
    }
    
    func switchedMode(mode: ShowsViewControllerMode) {
        switch mode {
        case .loading:
            showsView.loadingView.isHidden = false
            showsView.showListCollectionView.isHidden = true
        case .hasShows(let freshData, let isLast):
            showsView.loadingView.isHidden = true
            showsView.showListCollectionView.isHidden = false
            
            self.isInfiniteScrollEnabled = !isLast
            self.data = freshData
            showsView.showListCollectionView.reloadData()
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //----------------------------------------------------------------------
    // MARK: Collection View
    //----------------------------------------------------------------------
    func setupCollectionView() {
        showsCollectionView = showsView.showListCollectionView
        
        showsCollectionView.dataSource = self
        showsCollectionView.delegate = self
        showsCollectionView.register(ShowsCell.self, forCellWithReuseIdentifier: ShowsCell.identifier)
        showsCollectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)
        showsCollectionView.alwaysBounceVertical = true
    }
}

//----------------------------------------------------------------------
// MARK: API Calls
//----------------------------------------------------------------------
extension ShowsViewController {
    
    func initialLoadSeries() {
        apiManager?.getSeries(start: 0, quantity: numberOfShowsToLoad) {
            [weak self] series, isLast, error in
            if let error = error {
                // TODO: Show idle image/icon with error message (probably a new cell section)
                self?.alert?.mode = .showMessage(error)
                self?.mode = .hasShows([], isLast: true)
            } else {
                self?.mode = .hasShows(series, isLast: isLast)
            }
        }
    }
    
    func loadMoreOnDragDown() {
        apiManager?.getSeries(start: data.count, quantity: numberOfShowsToLoad) {
            [weak self] series, isLast, error in
            if let error = error {
                self?.alert?.mode = .showMessage(error) // show alert
                self?.isFetchingMore = false // stop displaying loading indicator
                self?.showsView.showListCollectionView.reloadSections(IndexSet(integer: 1)) // refresh the section with the spinner
            } else {
                self?.data += series
                self?.showsView.showListCollectionView.reloadData()
                self?.isFetchingMore = false // stop displaying loading indicator
                self?.isInfiniteScrollEnabled = !isLast
            }
        }
    }
    
    func refreshOnPull(completion: @escaping () -> ()) {
        apiManager?.getSeries(start: 0, quantity: numberOfShowsToLoad) {
            [weak self] series, isLast, error in
            if let error = error {
                self?.alert?.mode = .showMessage(error) // show alert
            } else {
                self?.data = series
                self?.showsView.showListCollectionView.reloadData()
                self?.isInfiniteScrollEnabled = !isLast
            }
            
            completion()
        }
    }
    
}

//----------------------------------------------------------------------
// Refresh on pull
//----------------------------------------------------------------------
extension ShowsViewController: ShowsViewDelegate {
    
    func refreshCollectionView(completion: @escaping () -> ()) {
        refreshOnPull(completion: completion)
    }
    
}

extension ShowsViewController: UICollectionViewDelegate {
    
    // Show cell tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tappedOnSeriesPoster(series: data[indexPath.item])
    }
}


//----------------------------------------------------------------------
// Scrolling: "Infinite Scroll"
//----------------------------------------------------------------------

extension ShowsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        guard offsetY > 0 else { return } // only when pulling up
        
        if offsetY > contentHeight - (scrollView.frame.height + 100) , !isFetchingMore { // mutlipled by 2 so it start loading data earlier
            beginBatchFetch()
        }
    }
    
    func beginBatchFetch() {
        guard isInfiniteScrollEnabled else {
            return
        }
        
        isFetchingMore = true
        showsView.showListCollectionView.reloadSections(IndexSet(integer: 1)) // refresh the section with the spinner
        
        loadMoreOnDragDown()
    }
}


//----------------------------------------------------------------------
// MARK: Data source
//----------------------------------------------------------------------

extension ShowsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // one section for shows & the other for the spinner
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return data.count
        } else if section == 1 && isFetchingMore {
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowsCell.identifier, for: indexPath) as! ShowsCell
            let data = self.data[indexPath.item]
            
            cell.posterURL = data.posterURL
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            
            return cell
        }
    }
    
}

//----------------------------------------------------------------------
// Scrolling: Flow layout
//----------------------------------------------------------------------

extension ShowsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return ShowsCell.cellSize // size of a cell
        } else if indexPath.section == 1 && isFetchingMore {
            return CGSize(width: collectionView.frame.width, height: 50) // size of the cell
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
           return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0) // overall insets of the collection view section
        } else if section == 1 && isFetchingMore {
            return UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 0) // overall insets of the collection view section
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0 // distance between rows
    }
}


