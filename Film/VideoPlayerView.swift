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
    
    var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    
    var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        
        return view
    }()
    
    var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        
        slider.minimumTrackTintColor = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.1764705882, alpha: 1)
        slider.thumbTintColor = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.1764705882, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
        
        return slider
    }()
    
    class Constraints {
        
        static let topBottomBarsHeight: CGFloat = 70.0
        
        static func setMediaView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        }
        
        static func setTopBar(_ view: UIView, _ parent: UIView) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: topBottomBarsHeight).isActive = true
        }
        
        static func setBottomBar(_ view: UIView, _ parent: UIView) {
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: topBottomBarsHeight).isActive = true
        }
        
        static func setSlider(_ slider: UISlider, _ parent: UIView) {
            let sliderDistanceFromEdge: CGFloat = 20.0
            let sliderDistanceFromBottom: CGFloat = 40.0
            
            slider.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -1 * sliderDistanceFromBottom).isActive = true
            slider.widthAnchor.constraint(equalTo: parent.widthAnchor, constant: -2 * sliderDistanceFromEdge ).isActive = true
            slider.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: sliderDistanceFromEdge).isActive = true
            //slider.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(mediaView)
        addSubviewLayout(topBar)
        addSubviewLayout(bottomBar)
        addSubviewLayout(slider)
        
        Constraints.setMediaView(mediaView, self)
        Constraints.setTopBar(topBar, self)
        Constraints.setBottomBar(bottomBar, self)
        Constraints.setSlider(slider, self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
