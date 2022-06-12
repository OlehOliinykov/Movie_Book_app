//
//  FilmModel.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import Foundation

struct FilmModel: Decodable, Equatable {
    let results: [Film]
}

struct Film: Decodable, Equatable {
    let title: String?
    let poster_path: String?
    let release_date: String
    let overview: String
}
