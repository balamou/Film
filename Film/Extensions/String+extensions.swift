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
    
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs, options: .caseInsensitive) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
