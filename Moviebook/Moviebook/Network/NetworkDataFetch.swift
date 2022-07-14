//
//  NetworkDataFetch.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import Foundation

class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchFilm(urlString: String, response: @escaping(FilmModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(urlString: urlString) {result in
            switch result {
            case .success(let data):
                do {
                    let films = try JSONDecoder().decode(FilmModel.self, from: data)
                    response(films, nil)
    
                } catch let jsonError {
                    print("Failed decode", jsonError)
                }
            
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }    
}
