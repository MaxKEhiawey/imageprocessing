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
    @Persisted var url: String
}
