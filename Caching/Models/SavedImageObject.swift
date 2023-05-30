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
    @Persisted var _originalImageData: Data
    @Persisted var _blurredImageData: Data
    @Persisted var isShowingOriginal: Bool
    var originalImage: UIImage {
        get { UIImage(data: _originalImageData) ?? UIImage() }
        set { _originalImageData = newValue.pngData() ?? Data() }
    }

    var blurredImage: UIImage {
        get { UIImage(data: _blurredImageData) ?? UIImage() }
        set { _blurredImageData = newValue.pngData() ?? Data() }
    }
}
