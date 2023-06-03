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
    @Published var zoomScale: CGFloat = 0.01
    @Published var myUIImage: UIImage = UIImage(systemName: "photo")!

        // change orientation
    private func selectOrientation(_ orientation: UIImage.Orientation, _ image: UIImage) {
        switch orientation {
        case .left:
            if let transformedImage = imgUtility.rotationImage(image: image, rotation: .left) {
                    myUIImage = transformedImage
                }
        case .up:
            if let transformedImage = imgUtility.rotationImage(image: image, rotation: .up) {
                    myUIImage = transformedImage
                }
        case .down:
            if let transformedImage = imgUtility.rotationImage(image: image, rotation: .down) {
                    myUIImage = transformedImage
                }
        case .right:
            if let transformedImage = imgUtility.rotationImage(image: image, rotation: .right) {
                    myUIImage = transformedImage
                }
        case .upMirrored:
            if let transformedImage = imgUtility.rotationImage(image: image, rotation: .upMirrored) {
                    myUIImage = transformedImage
                }
        case .downMirrored:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .downMirrored) {
                    myUIImage = transformedImage
                }
        case .leftMirrored:
            if let transformedImage = imgUtility.rotationImage(image: image, rotation: .leftMirrored) {
                    myUIImage = transformedImage
                }
        case .rightMirrored:
            if let transformedImage = imgUtility.rotationImage(image: image, rotation: .rightMirrored) {
                    myUIImage = transformedImage
                }
        @unknown default:
                print("Unknown move")
        }

    }
        // different image processing function
    func processImage(processType: ImageProcessings, originalImage: UIImage?) {
        if let activeImage = originalImage {
            DispatchQueue.global().async {
                DispatchQueue.main.async { [self] in
                    switch processType {
                    case .addFrame(type: let type):
                            selectFrame(type)
                    case .blurImage:
                        if let imageBlur = imgUtility.applyBlurToImage(activeImage, withRadius: 10.0) {
                                myUIImage = imageBlur
                            }
                    case .orientation(orientation: let orientation):
                            selectOrientation(orientation, myUIImage)
                    case .originalImage:
                            myUIImage = activeImage
                    case .zoomImage:
                            if let zoomedImage = imgUtility.applyZoomEffect(image: activeImage, zoomScale: zoomScale) {
                                myUIImage = zoomedImage
                            }
                    case .saveImage:
                           var savedImagesViewModel = SavedImagesVM()
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
            print("Image dimensions: \(width) x \(height)")
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
    case orientation(orientation: UIImage.Orientation)
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
