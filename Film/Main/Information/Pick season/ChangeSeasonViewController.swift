//
//  ChangeSeasonViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-09.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ChangeSeasonViewControllerDelegate: AnyObject {
    func seasonButtonTapped(season: Int)
    func closedButtonTapped()
}

class ChangeSeasonViewController: UIViewController {
    
    weak var delegate: ChangeSeasonViewControllerDelegate?
    var changeSeasonView: ChangeSeasonView!
    var totalSeasons: Int
    var selectedSeason: Int
    
    
    init(totalSeasons: Int, selectedSeason: Int) {
        self.totalSeasons = totalSeasons
        self.selectedSeason = selectedSeason
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeSeasonView = ChangeSeasonView()
        view = changeSeasonView
        
        changeSeasonView.seasonTableView.dataSource = self
        changeSeasonView.seasonTableView.delegate = self
        
        changeSeasonView.exitSeasonSelectorButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        delegate?.closedButtonTapped()
    }
}

extension ChangeSeasonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalSeasons
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row + 1)"
        
        if indexPath.row + 1  == selectedSeason {
            cell.textLabel?.font = Fonts.helveticaBold(size: 15.0)
        }
        
        return cell
    }
}

extension ChangeSeasonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.seasonButtonTapped(season: indexPath.row + 1)
    }
}
