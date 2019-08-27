//
//  ImageConstants.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class ImageConstants {
    
    // Tab View Controller Icons
    static let watchingImage: UIImage = #imageLiteral(resourceName: "Watching")
    static let showsImage: UIImage = #imageLiteral(resourceName: "Shows")
    static let moviesImage: UIImage = #imageLiteral(resourceName: "Movies")
    static let settingsImage: UIImage = #imageLiteral(resourceName: "Settings")
    
    // Watching View Controller Images
    static let idleImage: UIImage = #imageLiteral(resourceName: "Nothing_found")
    static let logoImage: UIImage = #imageLiteral(resourceName: "Logo")
    
    // Player View Controller Images
    static let pauseImage: UIImage = #imageLiteral(resourceName: "Pause")
    static let playImage: UIImage = #imageLiteral(resourceName: "Play")
    static let forwardImage: UIImage = #imageLiteral(resourceName: "forward")
    static let backwardImage: UIImage = #imageLiteral(resourceName: "backward")
    static let nextEpisodeImage: UIImage = #imageLiteral(resourceName: "Next_episode")
    static let volumeImage: UIImage = #imageLiteral(resourceName: "Volume")
    static let closeImage: UIImage = #imageLiteral(resourceName: "Close")
}

class FontStandard {
    
    static let defaultFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    
    static func helveticaNeue(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size) ?? defaultFont
    }
    
    static func RobotoCondensedBold(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: size) ?? defaultFont
    }
    
    // Helper method to display all fonts
    static func printAllFonts(subfamily: String? = nil) {
        print( UIFont.familyNames.reduce("") { $0 + "\n" + $1 })
        
        if let subfamily = subfamily {
            print( UIFont.fontNames(forFamilyName: subfamily).reduce("") { $0 + "\n" + $1 })
        }
    }
}
