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
    var originalImage: UIImage
    var blurredImage: UIImage
    var isShowingOriginal: Bool = false

    init(imageObject: SavedImageObject) {
        self.id = imageObject.id.stringValue
        self.originalImage = imageObject.originalImage
        self.blurredImage = imageObject.blurredImage
        self.isShowingOriginal = imageObject.isShowingOriginal
    }
}
