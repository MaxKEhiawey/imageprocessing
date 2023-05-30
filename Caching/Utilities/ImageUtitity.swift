//
//  ImageUtitity.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 25/05/2023.
//

import Foundation
import UIKit
import CoreImage

class ImageUtilities: ObservableObject {
    var images: [UIImage] = []
    func gaussianBlur(image: UIImage, blurRadius: CGFloat) -> UIImage {
        guard let ciImage =  CIImage(image: image), let ciFilter = CIFilter(name: "CIMotionBlur") else {
            return image
        }

        ciFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(130.0, forKey: kCIInputAngleKey)
        let outputImage = ciImage.applyingGaussianBlur(sigma: blurRadius)

        let context = CIContext(options: nil)

        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        return UIImage(cgImage: cgImage)
    }

    func removeBlurEffect(image: UIImage) -> UIImage {
            // Reverses the effect of the gaussianBlur function by applying a blank CIFilter
        guard let ciImage = CIImage(image: image),
              let ciFilter = CIFilter(name: "CIAffineTransform") else {
            return image
        }

        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = ciFilter.outputImage else {
            return image
        }

        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }

        return UIImage(cgImage: cgImage)
    }
}
