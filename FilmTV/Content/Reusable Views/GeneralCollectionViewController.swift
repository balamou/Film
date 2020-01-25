//
//  GeneralCollectionViewController.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

struct CellStyle {
    /// overall section inset
    var insets: UIEdgeInsets
    var columnDistance: CGFloat
    var rowDistance: CGFloat
    var size: ((CGFloat, CGFloat) -> CGSize)
    
    init(insets: UIEdgeInsets, columnDistance: CGFloat, rowDistance: CGFloat, size: @escaping ((CGFloat, CGFloat) -> CGSize) = {_,_ in .zero}) {
        self.insets = insets
        self.columnDistance = columnDistance
        self.rowDistance = rowDistance
        self.size = size
    }
    
    static var fill: CellStyle = {
        return CellStyle(insets: .zero,
                         columnDistance: 0,
                         rowDistance: 0,
                         size: { width, height in CGSize(width: width, height: height)})
    }()
}

class Section {
    typealias ConfigureCell = (UICollectionViewCell, Int) -> Void
    
    var cellType: AnyClass
    var identifier: String
    var numberOfItems: Int
    var isVisible: Bool
    var selectedCell: (Int) -> Void
    var populateCell: ConfigureCell?
    
    var cellStyle: CellStyle
   
    init(cellType: AnyClass,
         identifier: String,
         cellStyle: CellStyle = CellStyle.fill,
         numberOfItems: Int = 1,
         isVisible: Bool = false,
         selectedCell: @escaping (Int) -> Void = {_ in },
         populateCell: @escaping ConfigureCell = {_, _ in }) {
        self.cellType = cellType
        self.identifier = identifier
        self.cellStyle = cellStyle
        
        self.isVisible = isVisible
        self.numberOfItems = numberOfItems
        
        self.selectedCell = selectedCell
        self.populateCell = populateCell
    }
    
    func hide() {
        isVisible = false
    }
    
    func show() {
        isVisible = true
    }
}

protocol ScrollingDelegate: class {
    func batchFetch()
}

class GeneralCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var sections: [Section] = []
    weak var scrollingDelegate: ScrollingDelegate?
    
    init(sections: [Section]) {
        self.sections = sections
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
        
        sections.forEach {
            collectionView.register($0.cellType, forCellWithReuseIdentifier: $0.identifier)
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Data source
    //----------------------------------------------------------------------
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sections[section].isVisible {
            return sections[section].numberOfItems
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath)
        section.populateCell?(cell, indexPath.item)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        section.selectedCell(indexPath.item)
    }
    
    //----------------------------------------------------------------------
    // MARK: Scrolling: Flow layout
    //----------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].cellStyle.size(collectionView.frame.width, collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if sections[section].isVisible {
            return sections[section].cellStyle.insets
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].cellStyle.columnDistance // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].cellStyle.rowDistance // distance between rows
    }
    
    //----------------------------------------------------------------------
    // MARK: Scrolling
    //----------------------------------------------------------------------
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        guard offsetY > 0 else { return } // only when pulling up
        
        if offsetY > contentHeight - (scrollView.frame.height + 100) { // mutlipled by 2 so it start loading data earlier
            scrollingDelegate?.batchFetch()
        }
    }
}


