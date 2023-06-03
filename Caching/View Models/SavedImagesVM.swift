//
    //  SavedImagesVM.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 30/05/2023.
    //

import Foundation
import RealmSwift
import UIKit

class SavedImagesVM: ObservableObject {
    @ObservedResults(SavedImageObject.self) var savedImagesList
    @Published var allSaveimages: [SavedImage] = []
    private var token: NotificationToken?
    
    init() {
        fetchImages()
    }
    
    deinit {
        token?.invalidate()
    }
        // fetch all saved images with 👇🏽
    private func fetchImages() {
        do {
            let realm = try Realm()
            let results = realm.objects(SavedImageObject.self)
            
            token = results.observe({ [weak self] _ in
                self?.allSaveimages = results.map(SavedImage.init)
                    .sorted(by: { $0.id > $1.id })
            })
        } catch let error {
            print(error)
        }
    }
        // Delete contact
    func remove(id: String) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: id)
            if let image = realm.object(ofType: SavedImageObject.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(image)
                }
            }
        } catch let error {
            print(error)
        }
    }
        // Update image toggle
    func update(id: String, isShowingOriginal: Bool) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: id)
            if let image = realm.object(ofType: SavedImageObject.self, forPrimaryKey: objectId) {
                try realm.write {
                    image.isShowingOriginal = isShowingOriginal
                }
            }
        } catch let error {
            print(error)
        }
    }

        // Update image toggle
    func saveImage(processedImage: UIImage) {
        let image = SavedImageObject()
        image.processedImage = processedImage
        $savedImagesList.append(image)
    }
}
