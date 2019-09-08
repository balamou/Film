//
//  ShowInfoViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ShowInfoViewControllerDelegate: AnyObject {
    func exitButtonTapped()
    func playButtonTapped()
    func thumbnailTapped()
}


class ShowInfoViewController: UIViewController {
    
    var showView: ShowInfoView!
    weak var delegate: ShowInfoViewControllerDelegate?
    var seriesPresenter: SeriesPresenter?
    
    var data: Series = Series.getMock()
    var episodes: [Episode] = []
    
    // API
    //var apiManager:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showView = ShowInfoView()
        view = showView
        
        setupCollectionView()
        loadSeries(seriesPresenter: seriesPresenter)
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
    
    var episodesCollectionView: UICollectionView!
    
    func setupCollectionView() {
        episodesCollectionView = showView.episodesCollectionView
        
        episodesCollectionView.dataSource = self
        episodesCollectionView.delegate = self
        episodesCollectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.identifier)
        episodesCollectionView.alwaysBounceVertical = false
        
        episodesCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }
}

//----------------------------------------------------------------------
// MARK: API calls
//----------------------------------------------------------------------
extension ShowInfoViewController {
    
    func loadSeries(seriesPresenter: SeriesPresenter?) {
        guard let seriesPresenter = seriesPresenter else {
            return // TODO: Exit and show alert error
        }
        
        data.description = "LOLOLOLOLOL"
        episodesCollectionView.reloadData()
    }
    
}


//----------------------------------------------------------------------
// MARK: Delegate action
//----------------------------------------------------------------------

extension ShowInfoViewController: HeaderViewDelegate {
    
    func exitButtonTapped() {
        delegate?.exitButtonTapped()
    }
    
    func playButtonTapped() {
        // Play last watched episode
        delegate?.playButtonTapped()
    }
    
    func seasonButtonTapped() {
        // Open ChangeSeasonVC
        print("Change season")
    }
    
}

extension ShowInfoViewController: EpisodeCellDelegate {
    
    func thumbnailTapped() {
        // Play episode
        delegate?.thumbnailTapped()
    }
    
}

//----------------------------------------------------------------------
// MARK: Data Source
//----------------------------------------------------------------------
extension ShowInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.episodes.count
    }
    
    // Series Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        header.delegate = self
        
        header.populateData(series: data)
        
        return header
    }
    
    // Episode Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.identifier, for: indexPath) as! EpisodeCell
        cell.delegate = self
        let episode = data.episodes[indexPath.item]
        
        cell.populate(episode: episode)
        
        return cell
    }
    
    // Size of the header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return HeaderView.getEstimatedSize(description: data.description, collectionViewWidth: collectionView.frame.width)
    }
    
}

//----------------------------------------------------------------------
// MARK: Flow layout
//----------------------------------------------------------------------
extension ShowInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let episode = data.episodes[indexPath.item]
        return EpisodeCell.getEstimatedSize(plot: episode.plot, collectionViewWidth: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0) // overall insets of the collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0 // distance between rows
    }
}

