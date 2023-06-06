//
//  ImageEditingMethods.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 03/06/2023.
//

import Foundation
import CoreImage
import UIKit

class ImageEditingMethods: ObservableObject {
    private var imgUtility = ImageUtilities()
    @Published var savedImagesViewModel = SavedImagesVM()
    @Published var zoomScale: CGFloat = 0.0101
    @Published var blurRadius = 0.0
    @Published var isPortrait = false
    @Published var myUIImage: UIImage = UIImage(systemName: "photo")!

        // different image processing function
    func processImage(processType: ImageProcessings, originalImage: UIImage?) {
        if let activeImage = originalImage {
            DispatchQueue.global().async {
                DispatchQueue.main.async { [self] in
                    switch processType {
                    case .addFrame(type: let type):
                            selectFrame(type)
                    case .blurImage:
                            if let imageBlur = imgUtility.applyBlurToImage(activeImage, withRadius: blurRadius) {
                                myUIImage = imageBlur
                            }
                    case .orientation(isLeftLandscape: let isLeftLandscape, isPortrait: let isPortrait):
                            if isPortrait {
                                myUIImage = activeImage
                            } else {
                                if let changedImage = imgUtility.changeImageOrientation(activeImage, isPortrait: isLeftLandscape) {
                                    myUIImage = changedImage
                                }
                            }
                            // selectOrientation(orientation, myUIImage)
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
                            savedImagesViewModel.saveImage(processedImage: myUIImage)
                    }
                }
            }
        }
    }

    private func addFrame(frame: Frames) {
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

    private func selectFrame(_ type: Frames) {
        switch type {
        case .blackFrame:
                addFrame(frame: .blackFrame)
        case .darkWood:
                addFrame(frame: .darkWood)
        case .goldFrame:
                addFrame(frame: .goldFrame)
        case .lightWood:
                addFrame(frame: .lightWood)
        }
    }

    private func getImageDimensions(image: UIImage) -> (width: CGFloat, height: CGFloat)? {
        let imageSize = image.size
        let scale = image.scale
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return (width, height)
    }

}
enum ImageProcessings {
    case addFrame(type: Frames)
    case blurImage
    case orientation(isLeftLandscape: Bool, isPortrait: Bool)
    case originalImage
    case zoomImage
    case saveImage

}

enum Frames: String {
    case blackFrame = "BlackFrame"
    case darkWood = "DarkWoodFrame"
    case goldFrame = "GoldFrame"
    case lightWood = "LightWoodFrame"
}
