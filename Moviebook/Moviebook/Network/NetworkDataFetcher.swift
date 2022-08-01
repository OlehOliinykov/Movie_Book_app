//
//  NetworkDataFetcher.swift
//  Moviebook
//
//  Created by Влад Овсюк on 27.07.2022.
//

import Foundation

class NetworkDataFetcher {
    
//    var networkService = NetworkService()
    
    func fetchFilm(completion: @escaping (FilmModel?) -> ()) {
        NetworkService.shared.request() { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: FilmModel.self, from: data)
            completion(decode)
        }
    }
    
    func fetchGenre(completion: @escaping (GenreModel?) -> ()) {
        NetworkService.shared.genreRequest() { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: GenreModel.self, from: data)
            completion(decode)
        }
    }
    
    func fetchImage(completion: @escaping (ImageModel?) -> ()) {
        NetworkService.shared.imageRequest() { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: ImageModel.self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let JSONError {
            print("Failed to decode JSON", JSONError)
            return nil
        }
    }
    
}
