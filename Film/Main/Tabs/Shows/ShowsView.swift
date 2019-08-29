//
//  ShowsView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class ShowsView: UIView {
    
    lazy var navBar: CustomNavigationBar = {
        return CustomNavigationBar(title: "shows".localize(), showLogo: true)
    }()
    
    var showListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    // Loading view
    var loadingView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var spinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        
        return activityIndicator
    }()
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading...".localize()
        label.textColor = .white // NOTE: this is about to be deprecated
        label.font = FontStandard.RobotoCondensedBold(size: 18.0)
        
        return label
    }()
    
    class Constraints {
        
        static func setShowListCollectionView(_ collectionView: UICollectionView, _ navBar: UIView, _ parent: UIView) {
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
            collectionView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            collectionView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        // Loading View
        static func setLoadingView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        }
        
        static func setSpinner(_ activityIndicator: UIActivityIndicatorView, _ parent: UIView) {
            activityIndicator.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            activityIndicator.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setLoadingLabel(_ label: UILabel, _ topNeihgbour: UIView) {
            label.topAnchor.constraint(equalTo: topNeihgbour.bottomAnchor, constant: 10.0).isActive = true
            label.centerXAnchor.constraint(equalTo: topNeihgbour.centerXAnchor).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        addSubviewLayout(navBar)
        addSubviewLayout(showListCollectionView)
        
        navBar.setConstraints(parent: self)
        Constraints.setShowListCollectionView(showListCollectionView, navBar, self)
        
        // Loading View
        addSubviewLayout(loadingView)
        loadingView.addSubviewLayout(spinner)
        loadingView.addSubviewLayout(loadingLabel)
        
        Constraints.setLoadingView(loadingView, self)
        Constraints.setSpinner(spinner, loadingView)
        Constraints.setLoadingLabel(loadingLabel, spinner)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
