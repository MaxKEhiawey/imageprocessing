//
//  ImageUtility.swift
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

    func applyMotionBlur(to image: UIImage, blurRadius: CGFloat, angle: CGFloat) -> UIImage {
        guard let ciImage = CIImage(image: image),
              let ciFilter = CIFilter(name: "CIMotionBlur") else {
            return image
        }

        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        ciFilter.setValue(angle, forKey: kCIInputAngleKey)

        guard let outputImage = ciFilter.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }

        return UIImage(cgImage: cgImage)
    }
    func applyBlurToImage(_ image: UIImage, withRadius radius: CGFloat) -> UIImage? {
        guard let inputImage = CIImage(image: image) else {
            return nil
        }

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)

        guard let outputImage = filter?.outputImage else {
            return nil
        }

        let context = CIContext(options: nil)

        guard let cgImage = context.createCGImage(outputImage, from: inputImage.extent) else {
            return nil
        }

        let blurredImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        blurredImage.draw(in: CGRect(origin: .zero, size: image.size))
        let correctedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return correctedImage
    }
    func addImageFrame(to image: UIImage, frameImage: UIImage, frameSize: CGSize) -> UIImage? {
        let imageSize = image.size

        UIGraphicsBeginImageContextWithOptions(imageSize, false, image.scale)

            // Draw the original image
        image.draw(in: CGRect(origin: .zero, size: imageSize))

            // Calculate the frame position and size
        let frameOrigin = CGPoint(x: (imageSize.width - frameSize.width) / 2, y: (imageSize.height - frameSize.height) / 2)
        let frameRect = CGRect(origin: frameOrigin, size: frameSize)

            // Draw the frame image
        frameImage.draw(in: frameRect)

            // Retrieve the merged image
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return mergedImage
    }

    func applyZoomEffect(image: UIImage, zoomScale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: image.size.width * zoomScale, height: image.size.height * zoomScale)
        let newRect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        image.draw(in: newRect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func rotationImage(image: UIImage, rotation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        let imageRect = CGRect(origin: .zero, size: imageSize)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let context = CGContext(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: imageRect)
        guard let newCGImage = context.makeImage() else {
            return nil
        }

        let newImage = UIImage(cgImage: newCGImage, scale: image.scale, orientation: rotation)
        return newImage
    }
    func changeImageOrientation(_ image: UIImage, to orientation: UIInterfaceOrientation) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        var transform: CGAffineTransform
        switch orientation {
            case .portrait:
                transform = CGAffineTransform.identity
            case .landscapeLeft:
                transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            case .landscapeRight:
                transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            case .portraitUpsideDown:
                transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            default:
                transform = CGAffineTransform.identity
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()

        context?.concatenate(transform)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

}
