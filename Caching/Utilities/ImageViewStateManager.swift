//
//  ImageViewStateManager.swift
//  Caching
//
//  Created by Noye Samuel on 31/03/2023.
//

import Foundation

class ImageViewStateManager: ObservableObject {
    @Published var url: URL?
    @Published var key: String?
    
    init(url: URL?, key: String?) {
        self.url = url
        self.key = key
    }
}
