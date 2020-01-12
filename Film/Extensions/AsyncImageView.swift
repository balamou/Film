//
//  AsyncImageView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit
import Kingfisher

class AsyncImageView: UIImageView {
    private var currentURL: String?
    
    func loadImage(fromURL url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        kf.setImage(with: imageURL)
    }
    
    func loadImageAnimation(fromURL url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) -> () in
            print("Download Progress: \(receivedSize)/\(totalSize)")
            self.alpha = 0
        }, completionHandler: { result in
            switch result {
            case .success:
                print("Downloaded and set!")
                UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                    self.alpha = 1.0
                }, completion: nil)
            case .failure:
                return
            }
          
        })
    }
    
    func loadImageOLD(fromURL url: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let imageURL = URL(string: url) else { return }
        
        let cache = URLCache.shared
        let request = URLRequest(url: imageURL)
        
        currentURL = url
        guard let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) else {
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard self.currentURL == url else { return }
                
                guard let data = data, let response = response else { return }
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                guard statusCode < 300, let image = UIImage(data: data) else { return }
                
                let cachedURLResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedURLResponse, for: request)
                
                DispatchQueue.main.async {
                    self.transition(toImage: image)
                }
            }.resume()
            return
        }
        
        self.transition(toImage: image)
    }
    
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.image = image
        }, completion: nil)
    }
}
