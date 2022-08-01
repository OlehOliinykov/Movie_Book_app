//
//  GenreModel.swift
//  Moviebook
//
//  Created by Влад Овсюк on 28.07.2022.
//

import Foundation

struct GenreModel: Decodable, Equatable {
    let genres: [Genres]
}

struct Genres: Decodable, Equatable {
    let id: Int
    let name: String
}
