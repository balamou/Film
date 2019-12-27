//
//  RequestType.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-17.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct RequestType<ResponseType: Decodable> {
    let data: RequestData
    
    func execute(dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
                 onSuccess: @escaping (ResponseType) -> Void,
                 onError: @escaping (Error) -> Void) {
        
        dispatcher.dispatch(request: data, onSuccess: { responseData in
            do {
                let result = try JSONDecoder().decode(ResponseType.self, from: responseData)
                DispatchQueue.main.async { // UI Code is executed on the main thread!
                    onSuccess(result)
                }
            } catch let parseError {
                DispatchQueue.main.async {
                    onError(parseError)
                }
            }
        },
        onError: { error in
            DispatchQueue.main.async {
                onError(error)
            }
        })
        
    }
}
