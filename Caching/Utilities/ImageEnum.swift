//
//  ImageEnum.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 03/06/2023.
//

import Foundation

enum ImageProcessing {
    case addFrame(type: Frame)
    case blurImage
    case orientation(isLeftLandscape: Bool, isPortrait: Bool)
    case originalImage
    case zoomImage
    case saveImage

}

enum Frame: String {
    case blackFrame = "BlackFrame"
    case darkWood = "DarkWoodFrame"
    case goldFrame = "GoldFrame"
    case lightWood = "LightWoodFrame"
    case clear = "Clear"
}
