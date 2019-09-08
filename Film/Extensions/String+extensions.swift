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
    
    func truncate(_ length: Int?) -> String {
        guard let length = length else {
            return self
        }
        
        return truncate(length: length)
    }
    
    private func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            let prefixAndRemoveWhiteSpace = self.prefix(length).trimmingCharacters(in: .whitespaces)
            
            return prefixAndRemoveWhiteSpace + trailing
        }
            
        return self
    }
}
