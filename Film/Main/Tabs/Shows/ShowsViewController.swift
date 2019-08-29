//
//  ShowsViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


enum ShowsViewControllerMode {
    case loading
    case hasShows([SeriesPresenter])
}

class ShowsViewController: UIViewController {
    
    var showsView: ShowsView!
    weak var showsCollectionView: UICollectionView!
    var isFetchingMore = false
    var data: [SeriesPresenter] = SeriesPresenter.getMockData()
    var mode: ShowsViewControllerMode = .loading {
        didSet {
            switch mode {
            case .loading:
                showsView.loadingView.isHidden = false
                showsView.showListCollectionView.isHidden = true
            case .hasShows(let freshData):
                showsView.loadingView.isHidden = true
                showsView.showListCollectionView.isHidden = false
                
                self.data = freshData
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showsView = ShowsView()
        view = showsView
        
        setupCollectionView()
        
        // TMP CODE
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTMP))
        showsView.navBar.logoImage.isUserInteractionEnabled = true
        showsView.navBar.logoImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedTMP() {
        
        switch mode{
        case .loading:
            mode = .hasShows(data)
        case .hasShows(_):
            mode = .loading
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
        
        if offsetY > contentHeight - scrollView.frame.height, !isFetchingMore {
            beginBatchFetch()
        }
    }
    
    func beginBatchFetch() {
        isFetchingMore = true
        print("beginBatchFetch!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            // fake API call
            self.data += SeriesPresenter.getMockData()
            self.showsView.showListCollectionView.reloadData()
            self.isFetchingMore = false
        })
    }
}

extension ShowsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowsCell.identifier, for: indexPath) as! ShowsCell
        let data = self.data[indexPath.item]
        
        cell.posterURL = data.posterURL
        
        return cell
    }
    
}

extension ShowsViewController: UICollectionViewDelegate {
    
    // Item selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Open Show Description
        
        if indexPath.row == 0 {
            navigationController?.pushViewController(ShowInfoViewController(), animated: false)
        }
    }
}

extension ShowsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 160) // size of a cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0) // overall insets of the collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0 // distance between rows
    }
}


