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
    var isFetchingMore = false
    var isInfiniteScrollEnabled = true
    var data: [SeriesPresenter] = []
    var mode: ShowsViewControllerMode = .loading {
        didSet {
            switchedMode(mode: mode)
        }
    }
    // API
    var apiManager: SeriesMoviesAPI?
    let numberOfShowsToLoad = 9
    weak var delegate: ShowsDelegate?
    lazy var alert: AlertViewController = {
        let alert = AlertViewController()
        alert.addAsChild(self)
        
        return alert
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showsView = ShowsView()
        view = showsView
        showsView.delegate = self
        
        _ = alert // initialize lazy alert
        setupCollectionView()
        preloadSeries()
    }
    
    func preloadSeries() {
        apiManager?.getSeries(start: data.count, quantity: numberOfShowsToLoad) {
            [weak self] series, isLast, error in
            if let error = error {
                // TODO: Show idle image/icon with error message
                self?.alert.mode = .showMessage(error)
                self?.showsView.showListCollectionView.reloadSections(IndexSet(integer: 1)) // refresh the section with the spinner
            } else {
                self?.mode = .hasShows(series, isLast: isLast)
            }
        }
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
// Scrolling: "Infinite Scroll"
//----------------------------------------------------------------------

extension ShowsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 2, !isFetchingMore { // mutlitpled by 2 so it start loading data earlier
            beginBatchFetch()
        }
    }
    
    func beginBatchFetch() {
        guard isInfiniteScrollEnabled else {
            return
        }
        
        print("Get more shows")
        isFetchingMore = true
        showsView.showListCollectionView.reloadSections(IndexSet(integer: 1)) // refresh the section with the spinner
        
        makeAPICall()
    }
    
    func makeAPICall() {
        apiManager?.getSeries(start: data.count, quantity: numberOfShowsToLoad) {
            [weak self] series, isLast, error in
            if let error = error {
                self?.alert.mode = .showMessage(error) // show alert
                self?.isFetchingMore = false // stop displaying loading indicator
                self?.showsView.showListCollectionView.reloadSections(IndexSet(integer: 1)) // refresh the section with the spinner
            } else {
                self?.data += SeriesPresenter.getMockData()
                self?.showsView.showListCollectionView.reloadData()
                self?.isFetchingMore = false // stop displaying loading indicator
                self?.isInfiniteScrollEnabled = !isLast
            }
        }
    }
}


//----------------------------------------------------------------------
// Refresh on scroll
//----------------------------------------------------------------------
extension ShowsViewController: ShowsViewDelegate {
    
    func refreshCollectionView(completion: @escaping () -> ()) {
        apiManager?.getSeries(start: 0, quantity: numberOfShowsToLoad) {
            [weak self] series, isLast, error in
            if let error = error {
                self?.alert.mode = .showMessage(error) // show alert
            } else {
                self?.data = SeriesPresenter.getMockData()
                self?.showsView.showListCollectionView.reloadData()
                self?.isInfiniteScrollEnabled = !isLast
            }
            
            completion()
        }
    }
    
}


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

extension ShowsViewController: UICollectionViewDelegate {
    
    // Item selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tappedOnSeriesPoster(series: data[indexPath.item])
    }
}

extension ShowsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 110, height: 160) // size of a cell
        } else if indexPath.section == 1 && isFetchingMore {
            return CGSize(width: collectionView.frame.width, height: 50)
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


