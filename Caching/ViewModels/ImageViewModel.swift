//
    //  ImageViewModel.swift
    //  Caching
    //
    //  Created by Noye Samuel on 29/03/2023.
    //

import Combine
import UIKit

class ImageViewModel: ObservableObject {
    @Published var images: [UnsplashImage] = []
    @Published var isLoading = true
    var networkManager = NetworkManager()
    init(dataService: NetworkManager) {
        self.networkManager = dataService
        self.getImages()
    }
    var cancellables = Set<AnyCancellable>()
    
    func getImages(addImages: Bool = false) {

        if images.isEmpty {
            self.isLoading = true
        }
        networkManager.getImages()
            .sink { _ in
                self.isLoading = false
            }  receiveValue: { [weak self] returnedimages in
                if addImages {
                    print("adding to realm")
                    self?.addToRealm(images: returnedimages)
                }
                     self?.images = returnedimages
            }
            .store(in: &cancellables)
    }
    func addToRealm(images: [UnsplashImage]) {
        for fetchImage in images {
                let savedImagesViewModel = SavedImagesVM()
                savedImagesViewModel.saveImage(savedImage: fetchImage.urls.small)
        }
    }
}
