//
//  UIImageView+extensions.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()


extension UIImageView {
    
    func downloaded(from url: URL, urlString: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = imageFromCache
            
            return 
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                let imageToCache = image
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
                
                self.image = imageToCache
            }
            }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, urlString: link , contentMode: mode)
    }
}
