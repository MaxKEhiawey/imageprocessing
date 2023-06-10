//
    //  SavedImages.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 30/05/2023.
    //

import Foundation
import UIKit
    // ContactModel
struct SavedImage: Identifiable, Equatable {
    var id: String
    var url: String
    init(imageObject: SavedImageObject) {
        self.id = imageObject.id.stringValue
        self.url = imageObject.url
    }
}

struct ProcessedImage: Identifiable, Equatable {
    var id: String
    var processedImage: UIImage
    init(imageObject: ProcessedImageObject) {
        self.id = imageObject.id.stringValue
        self.processedImage = imageObject.processedImage
    }
}
