//
//  Models.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation

struct UnsplashImage: Decodable, Identifiable, Equatable  {
    let id: String
    let urls: UnsplashImageUrls
}

struct UnsplashImageUrls: Decodable, Equatable  {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}
