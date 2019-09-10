//
//  ChangeSeasonView.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-09.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class ChangeSeasonView: UIView {
    
    var seasonTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    var bottomOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    var exitSeasonSelectorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        
        return button
    }()
    
    class Constraints {
        
        static func setTableView(_ tableView: UITableView, _ parent: UIView) {
            tableView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        }
        
        static func setBottomOverlayView(_ view: UIView, _ parent: UIView) {
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
        
        static func setExitSeasonSelectorButton(_ button: UIButton, _ parent: UIView) {
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(seasonTableView)
        addSubviewLayout(bottomOverlayView)
        bottomOverlayView.addSubviewLayout(exitSeasonSelectorButton)
        
        Constraints.setTableView(seasonTableView, self)
        Constraints.setBottomOverlayView(bottomOverlayView, self)
        Constraints.setExitSeasonSelectorButton(exitSeasonSelectorButton, bottomOverlayView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

