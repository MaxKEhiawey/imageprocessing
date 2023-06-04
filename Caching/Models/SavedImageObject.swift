//
//  SavedImagesObject.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import Foundation
import RealmSwift
import UIKit

class SavedImageObject: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var blurredImageData: Data

    var processedImage: UIImage {
        get { UIImage(data: blurredImageData) ?? UIImage() }
        set { blurredImageData = newValue.pngData() ?? Data() }
    }
}
