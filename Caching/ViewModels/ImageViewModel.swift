    //
    //  ImageViewModel.swift
    //  Caching
    //
    //  Created by Noye Samuel on 29/03/2023.
    //

import Combine
import UIKit

class ImageViewModel: ObservableObject {

    private var imgUtility = ImageUtility()
    @Published var zoomScale: CGFloat = 0.0101
    @Published var blurRadius = 0.0
    @Published var isPortrait = false
    @Published var myUIImage: UIImage = UIImage(systemName: "cart")!
    @Published var originalImage: UIImage? = UIImage(systemName: "photo")!
    @Published var images: [UnsplashImage] = []
    @Published var isLoading = true
    var networkManager = NetworkManager()
    @Published var imageDisplayed: UIImage?
    @Published var changedImageUrl = ""
    @Published var imageIndex = 0 
    @Published var selectedImagekey: String = ""

    init(dataService: NetworkManager) {
        self.networkManager = dataService
        self.getImages()
    }
        // different image processing function
    func processImage(processType: ImageProcessing) {
        print(myUIImage)
        if let activeImage = originalImage {
            DispatchQueue.global().async {
                DispatchQueue.main.async { [self] in
                    switch processType {
                    case .addFrame(type: let type):
                            selectFrame(type, mainImage: activeImage)
                    case .blurImage:
                            if let imageBlur = imgUtility.applyBlurToImage(activeImage, withRadius: blurRadius) {
                                myUIImage = imageBlur
                            }
                    case .orientation(isLeftLandscape: let isLeftLandscape, isPortrait: let isPortrait):
                            if isPortrait {
                                myUIImage = myUIImage
                                if let changedImage = imgUtility.changeImageOrientation(activeImage, isPortrait: isLeftLandscape) {
                                    myUIImage = changedImage
                                }
                            }
                    case .originalImage:
                            zoomScale=0.0101
                            blurRadius=1.0
                            myUIImage = activeImage
                    case .zoomImage:
                            if let zoomedImage = imgUtility.zoomImage(activeImage, zoomFactor: zoomScale) {
                                myUIImage = zoomedImage
                            }
                    case .saveImage:
                            let savedImagesViewModel = SavedImagesVM()
                                // savedImagesViewModel.saveImage(processedImage: myUIImage)
                    }
                }
            }
        }
    }

    private func addFrame(frame: Frame, mainImage: UIImage) {
        var width = 0.0
        var height = 0.0

        if let dimensions = getImageDimensions(image: myUIImage) {
            width = dimensions.width
            height = dimensions.height
        } else {
            print("Failed to retrieve image dimensions")
        }
        let frameSize = CGSize(width: width, height: height)
        if let frameImage = UIImage(named: frame.rawValue) {
            if let selectedFrame = imgUtility.addImageFrame(to: myUIImage, frameImage: frameImage, frameSize: frameSize) {
                myUIImage = selectedFrame
            }
        }
    }

    private func selectFrame(_ type: Frame, mainImage: UIImage) {
        switch type {
        case .blackFrame:
                addFrame(frame: .blackFrame, mainImage: mainImage)
        case .darkWood:
                addFrame(frame: .darkWood, mainImage: mainImage)
        case .goldFrame:
                addFrame(frame: .goldFrame, mainImage: mainImage)
        case .lightWood:
                addFrame(frame: .lightWood, mainImage: mainImage)
        }
    }

    private func getImageDimensions(image: UIImage) -> (width: CGFloat, height: CGFloat)? {
        let imageSize = image.size
        let scale = image.scale
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return (width, height)
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

    func setImageIndex() {
        DispatchQueue.main.async { [self] in
            for (index, image) in images.enumerated() where image.id == selectedImagekey {
                imageIndex = index
                print("ImageIndex", index, "image URL:", images[imageIndex].urls.regular)
                changedImageUrl = images[imageIndex].urls.regular
                updateImage()
            }
        }
    }
    private func updateImage() {
        guard let imageURL = URL(string: changedImageUrl) else {
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.imageDisplayed = UIImage(data: data)
            }
        }.resume()
    }

    func addToRealm(images: [UnsplashImage]) {
        for fetchImage in images {
            //DispatchQueue.main.async {
                let savedImagesViewModel = SavedImagesVM()
                savedImagesViewModel.saveImage(savedImage: fetchImage.urls.small)
          //  }
        }
    }
}
