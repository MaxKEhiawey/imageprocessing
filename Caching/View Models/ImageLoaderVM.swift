//
//  File.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import Combine
import SwiftUI

class ImageLoaderVM: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = true
    @Published var url: URL
    @Published var imgKey: String
    var cancellables = Set<AnyCancellable>()
    let cache = CacheManager.shared
    
    init(url: URL, key: String) {
        self.url = url
        self.imgKey = key
        self.loadImage()
    }
    
    func loadImage() {
        if let savedImages = cache.get(key: imgKey) {
            image = savedImages
            isLoading = false
        } else {
            downloadImages()
            print("downloading image..")
        }
    }
    
    func downloadImages() {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.isLoading = false
            } receiveValue: { [weak self] returnedimage in
                guard let self = self, let img = returnedimage else { return }
                self.image = returnedimage
                self.cache.add(key: self.imgKey, image: img)
            }
            .store(in: &cancellables)
    }
}
