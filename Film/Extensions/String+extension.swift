//
//  String+extension.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

extension String {
    
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
