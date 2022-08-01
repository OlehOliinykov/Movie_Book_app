//
//  NetworkService.swift
//  Moviebook
//
//  Created by Влад Овсюк on 26.07.2022.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    let apiKey = "f048e427d91bfded37eee1e7a69876fd"
    var idValue: Int?
    
    func request(completion: @escaping (Data?, Error?) -> Void) {
        let parameters = prepareParameters()
        
        let filmURL = filmURL(params: parameters)
        var filmRequest = URLRequest(url: filmURL)
        filmRequest.httpMethod = "get"
        let filmTask = createDataTask(from: filmRequest, completion: completion)
        filmTask.resume()
    }
    
    func genreRequest(completion: @escaping (Data?, Error?) -> Void) {
        guard let idValue = idValue else { return }
        let parameters = prepareParameters()
        let genreURL = genreURL(params: parameters, id: idValue)
        var genreRequest = URLRequest(url: genreURL)
        genreRequest.httpMethod = "get"
        let genreTask = createDataTask(from: genreRequest, completion: completion)
        genreTask.resume()
    }
    
    func imageRequest(completion: @escaping (Data?, Error?) -> Void) {
        let parameters = prepareParameters()
        let imageURL = imageURL(params: parameters)
        var imageRequest = URLRequest(url: imageURL)
        imageRequest.httpMethod = "get"
        let imageTask = createDataTask(from: imageRequest, completion: completion)
        imageTask.resume()
    }
    
    private func prepareParameters() -> [String: String] {
        var parameters = [String: String]()
        parameters["api_key"] = apiKey
        return parameters
    }
    
    private func filmURL(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/trending/movie/week"
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        return components.url!
    }
    
    private func genreURL(params: [String: String], id: Int) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/movie/\(String(describing: id))"
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        return components.url!
    }
    
    private func imageURL(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/configuration"
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
