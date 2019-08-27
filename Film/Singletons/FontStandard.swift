//
//  FontStandard.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class FontStandard {
    
    static let defaultFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    
    static func helveticaNeue(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size) ?? defaultFont
    }
    
    static func RobotoCondensedBold(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: size) ?? defaultFont
    }
    
    static func RobotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Black", size: size) ?? defaultFont
    }
    
    // Helper method to display all fonts
    static func printAllFonts(subfamily: String? = nil) {
        print( UIFont.familyNames.reduce("") { $0 + "\n" + $1 })
        
        if let subfamily = subfamily {
            print( UIFont.fontNames(forFamilyName: subfamily).reduce("") { $0 + "\n" + $1 })
        }
    }
}
