//
//  NetworkManager.swift
//  EvaluationTest
//
//  Created by Константин Сабицкий on 04.09.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation
import UIKit
class NetworkManager {
    
    let mainUrl = URL(string: "https://itunes.apple.com/search?")
    var searchResults = [SearchItem]()
    lazy var urlSession = URLSession.shared
    
    func getData(by searchTerm: String, entity: String?, page: Int, limit: Int, completion: @escaping ([SearchItem]) -> Void) {
            guard let mainUrl = mainUrl else { return }
            var urlComponents = URLComponents(url: mainUrl, resolvingAgainstBaseURL: true)
            ///I've decided to limit data searching by media type "music" only
            let parametres = ["term": searchTerm,
                              "entity": entity,
                              "media": "music",
                              "limit": "\(limit)",
                              "offset": "\(page * limit)"]
            let queryItems = parametres.compactMap {URLQueryItem(name: $0.key, value: $0.value)}
            urlComponents?.queryItems = queryItems
            guard let requestUrl = urlComponents?.url else { return }
            print(requestUrl)
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "GET"
        let dataTask = urlSession.dataTask(with: request) { (data, resp, err) in
            if let err = err { print("Request Error occured: \(err)") }
            guard let data = data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let resultsArray = try jsonDecoder.decode(Results.self, from: data)
                //
                guard let results = resultsArray.results else { return }
                //print(results)
                completion(results)
            } catch {

            }
            
        }
        dataTask.resume()
 
        
    }
    
}

