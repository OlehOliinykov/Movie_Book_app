//
//  NetworkService.swift
//  Moviebook
//
//  Created by Влад Овсюк on 26.07.2022.
//

import Foundation

class NetworkService {
    
    let apiKey = "f048e427d91bfded37eee1e7a69876fd"
    
    func request(completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParameters()
        let url = self.url(params: parameters)
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParameters() -> [String: String] {
        var parameters = [String: String]()
        parameters["api_key"] = apiKey
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/trending/movie/week"
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
