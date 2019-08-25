//
//  VideoPlayerView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class VideoPlayerView: UIView {
    
    var mediaView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    class Constraints {
        
        static func setMediaView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviewLayout(mediaView)
        
        Constraints.setMediaView(mediaView, self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
