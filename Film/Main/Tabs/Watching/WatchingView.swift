//
//  WatchingView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol WatchingViewDelegate: AnyObject {
    func refreshCollectionView(completion: @escaping () -> ())
}

class WatchingView: UIView {
    
    weak var delegate: WatchingViewDelegate?
    
    lazy var navBar: CustomNavigationBar = {
        return CustomNavigationBar(title: "watching".localize(), showLogo: true)
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTriggered(_:)), for: .valueChanged)
        
        return collectionView
    }()
    
    @objc func refreshTriggered(_ sender: UIRefreshControl) {
        delegate?.refreshCollectionView {
            sender.endRefreshing()
        }
    }
    
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
    
    // IDLE
    var idleView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        return view
    }()
    
    var idleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageConstants.idleImage
        
        return imageView
    }()
    
    var idleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing watched yet".localize()
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.231372549, blue: 0.231372549, alpha: 1)
        label.font = FontStandard.RobotoCondensedBold(size: 25.0)
        
        return label
    }()
    
    class Constraints {
        
        static func setCollectionView(_ collectionView: UICollectionView, _ navBar: UIView, _ parent: UIView) {
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
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
        
        // IDLE
        static func setIdleView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        }
        
        static func setIdleImage(_ imageView: UIImageView, _ parent: UIView) {
            imageView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setIdleLabel(_ label: UILabel, _ topNeighbour: UIView) {
            label.centerXAnchor.constraint(equalTo: topNeighbour.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 20.0).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        addSubviewLayout(navBar)
        navBar.setConstraints(parent: self)
       
        addSubviewLayout(collectionView)
        Constraints.setCollectionView(collectionView, navBar, self)
        
        addSubviewLayout(idleView)
        idleView.addSubviewLayout(idleImage)
        idleView.addSubviewLayout(idleLabel)
        
        addSubviewLayout(loadingView)
        loadingView.addSubviewLayout(spinner)
        loadingView.addSubviewLayout(loadingLabel)
        
        Constraints.setIdleView(idleView, self)
        Constraints.setIdleImage(idleImage, idleView)
        Constraints.setIdleLabel(idleLabel, idleImage)
        
        Constraints.setLoadingView(loadingView, self)
        Constraints.setSpinner(spinner, loadingView)
        Constraints.setLoadingLabel(loadingLabel, spinner)
        
        idleView.bottomAnchor.constraint(equalTo: idleLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
