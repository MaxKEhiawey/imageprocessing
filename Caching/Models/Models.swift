//
//  Models.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation

struct UnsplashImage: Decodable, Identifiable {
    let id: String
    let urls: UnsplashImageUrls
}

struct UnsplashImageUrls: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
