//
//  ShowInfoViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol ShowInfoViewControllerDelegate: class {
    func showInfoViewControllerDidExit(_ showInfoViewController: ShowInfoViewController)
    func showInfoViewController(_ showInfoViewController: ShowInfoViewController, play episode: Episode)
    func showInfoViewController(_ showInfoViewController: ShowInfoViewController, exitWith error: Error)
}

class ShowInfoViewController: UIViewController {
    
    weak var delegate: ShowInfoViewControllerDelegate?
    private var showView: ShowInfoView!
    
    private var series: Series
    private var episodes: [Episode] = []
    
    private var isLoadingEpisodes = true
    
    private var changeSeasonsVC: ChangeSeasonViewController?
    
    // API
    var apiManager: SeriesInfoAPI?
    
    init(series: Series) {
        self.series = series
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showView = ShowInfoView()
        view = showView
        
        setupCollectionView()
        fetchSeries(by: series.id)
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
        episodesCollectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)
        
        episodesCollectionView.alwaysBounceVertical = false
        
        episodesCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }
}

//----------------------------------------------------------------------
// MARK: API calls
//----------------------------------------------------------------------
extension ShowInfoViewController {
    
    func fetchSeries(by seriesId: Int) {
        apiManager?.getSeriesInfo(seriesId: seriesId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success((let seriesData, let episodes)):
                self.series = seriesData
                self.episodes = episodes
                self.isLoadingEpisodes = false
                self.episodesCollectionView.reloadData()
            case .failure(let error):
                self.delegate?.showInfoViewController(self, exitWith: error)
            }
            
        }
    }
    
    func fetchEpisodes(from season: Int) {
        isLoadingEpisodes = true
        episodesCollectionView.reloadData()
        
        apiManager?.getEpisodes(seriesId: series.id, season: season) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let episodes):
                self.episodes = episodes
                self.isLoadingEpisodes = false
                self.episodesCollectionView.reloadData()
            case .failure(let error):
                self.delegate?.showInfoViewController(self, exitWith: error)
            }
        }
    }
    
}


//----------------------------------------------------------------------
// MARK: Delegate action
//----------------------------------------------------------------------

extension ShowInfoViewController: HeaderViewDelegate {
    
    func exitButtonTapped() {
        delegate?.showInfoViewControllerDidExit(self)
    }
    
    func playButtonTapped() {
        // Play last watched episode or first episode
        guard let episode = series.lastWatchedEpisode else { return }
        
        delegate?.showInfoViewController(self, play: episode)
    }
    
    func seasonButtonTapped() {
        let changeSeasonsVC = ChangeSeasonViewController(totalSeasons: series.totalSeasons,
                                                         selectedSeason: series.seasonSelected)
        self.changeSeasonsVC = changeSeasonsVC
        changeSeasonsVC.delegate = self
        
        addChildViewController(child: changeSeasonsVC)
        changeSeasonsVC.view.fillConstraints(in: view)
    }
    
}

extension ShowInfoViewController: EpisodeCellActionable {
    
    func thumbnailTapped(at row: Int) {
        // Play episode
        let episode = episodes[row]
        delegate?.showInfoViewController(self, play: episode)
    }
    
}

extension ShowInfoViewController: ChangeSeasonViewControllerDelegate {
    
    func changeSeasonViewControllerExit(_ changeSeasonViewController: ChangeSeasonViewController) {
        changeSeasonsVC?.removeSelfAsChildViewController()
    }
    
    func changeSeasonViewController(_ changeSeasonViewController: ChangeSeasonViewController, selected season: Int) {
        fetchEpisodes(from: season)
        series.seasonSelected = season
        episodesCollectionView.reloadData()
        
        changeSeasonsVC?.removeSelfAsChildViewController()
    }
    
}

//----------------------------------------------------------------------
// MARK: Data Source
//----------------------------------------------------------------------
extension ShowInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // one section for the list of episodes & the other for the spinner
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && !isLoadingEpisodes {
            return episodes.count
        } else if section == 1 && isLoadingEpisodes {
            return 1
        }
        
        return 0
    }
    
    // Series Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        header.delegate = self
        
        header.populateData(series: series)
        
        return header
    }
    
    // Episode Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.identifier, for: indexPath) as! EpisodeCell
            cell.delegate = self
            let episode = episodes[indexPath.item]
            
            cell.rowNumber = indexPath.row
            cell.populate(episode: episode)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            
            return cell
        }
    }
    
    // Size of the header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return HeaderView.getEstimatedSize(description: series.description, collectionViewWidth: collectionView.frame.width)
        }
        
        return .zero
    }
    
}

//----------------------------------------------------------------------
// MARK: Flow layout
//----------------------------------------------------------------------
extension ShowInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let episode = episodes[indexPath.item]
            return EpisodeCell.getEstimatedSize(plot: episode.plot, collectionViewWidth: collectionView.frame.width)
        } else if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.width, height: 50) // size of the cell
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0) // overall insets of the collection view
        } else if section == 1 && isLoadingEpisodes {
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0 // distance between rows
    }
}

