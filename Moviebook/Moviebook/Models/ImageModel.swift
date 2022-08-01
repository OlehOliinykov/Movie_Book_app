//
//  ImageModel.swift
//  Moviebook
//
//  Created by Влад Овсюк on 28.07.2022.
//

import Foundation

struct ImageModel: Decodable, Equatable {
    let images: Image
}

struct Image: Decodable, Equatable {
    let secure_base_url: String
    let poster_sizes: [String]
}
