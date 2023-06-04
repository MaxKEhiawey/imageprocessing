//
//  SavedImages.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import Foundation
import UIKit
    // ContactModel
struct SavedImage: Identifiable {
    var id: String
    var processedImage: UIImage

    init(imageObject: SavedImageObject) {
        self.id = imageObject.id.stringValue
        self.processedImage = imageObject.processedImage
    }
}
