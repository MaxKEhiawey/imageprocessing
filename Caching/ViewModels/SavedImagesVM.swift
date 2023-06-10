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
    @ObservedResults(ProcessedImageObject.self) var processedImagesList
    @Published var allSaveimages: [SavedImage] = []
    @Published var processedImages: [ProcessedImage] = []
    private var token: NotificationToken?
    @Published var imageIndex: Int = 0

    private var imgUtility = ImageUtility()
    @Published var zoomScale: CGFloat = 0.0101
    @Published var blurRadius = 0.0
    @Published var isPortrait = false
    @Published var imageDisplayed: UIImage?
    @Published var myUIImage: UIImage = UIImage(systemName: "cart")!
    @Published var originalImage: UIImage? = UIImage(systemName: "photo")!
    @Published var changedImageUrl = ""

    init() {
        fetchSavedImages()
    }
    
    deinit {
        token?.invalidate()
    }

        // fetch all saved image urls with
    private func fetchSavedImages() {
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
        // Delete saved image URLs
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
        // add image toggle
    func saveImage(savedImage: String) {
        let image = SavedImageObject()
        image.url = savedImage
        $savedImagesList.append(image)
    }
        // fetch all processed image urls with
   func fetchProcessedImages() {
        do {
            let realm = try Realm()
            let results = realm.objects(ProcessedImageObject.self)

            token = results.observe({ [weak self] _ in
                self?.processedImages = results.map(ProcessedImage.init)
                    .sorted(by: { $0.id > $1.id })
            })
        } catch let error {
            print(error)
        }
    }
        // add image toggle
    func saveProcessedImage(processedImage: UIImage) {
        let image = ProcessedImageObject()
        image.processedImage = processedImage
        $processedImagesList.append(image)
    }
        // Delete saved image URLs
    func removeProcessed(id: String) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: id)
            if let image = realm.object(ofType: ProcessedImageObject.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(image)
                }
            }
        } catch let error {
            print(error)
        }
    }
        // different image processing function
    func processImage(processType: ImageProcessing) {

        if let activeImage = originalImage {
            DispatchQueue.global().async {
                DispatchQueue.main.async { [self] in
                    switch processType {
                    case .addFrame(type: let type):
                            selectFrame(type, mainImage: activeImage)
                    case .blurImage:
                            if let imageBlur = imgUtility.applyBlurToImage(activeImage, withRadius: blurRadius) {
                                myUIImage = imageBlur
                            }
                    case .orientation(isLeftLandscape: let isLeftLandscape, isPortrait: let isPortrait):
                            if isPortrait {
                                myUIImage = myUIImage
                                if let changedImage = imgUtility.changeImageOrientation(activeImage, isPortrait: isLeftLandscape) {
                                    myUIImage = changedImage
                                }
                            }
                    case .originalImage:
                            zoomScale=0.0101
                            blurRadius=1.0
                            myUIImage = activeImage
                    case .zoomImage:
                            if let zoomedImage = imgUtility.zoomImage(activeImage, zoomFactor: zoomScale) {
                                myUIImage = zoomedImage
                            }
                    case .saveImage:
                            let savedImagesViewModel = SavedImagesVM()
                               saveProcessedImage(processedImage: myUIImage)
                    }
                }
            }
        }
    }

    private func addFrame(frame: Frame, mainImage: UIImage) {
        var width = 0.0
        var height = 0.0

        if let dimensions = getImageDimensions(image: myUIImage) {
            width = dimensions.width
            height = dimensions.height
        } else {
            print("Failed to retrieve image dimensions")
        }
        let frameSize = CGSize(width: width, height: height)
        if let frameImage = UIImage(named: frame.rawValue) {
            if let selectedFrame = imgUtility.addImageFrame(to: myUIImage, frameImage: frameImage, frameSize: frameSize) {
                myUIImage = selectedFrame
            }
        }
    }

    private func selectFrame(_ type: Frame, mainImage: UIImage) {
        switch type {
        case .blackFrame:
                addFrame(frame: .blackFrame, mainImage: mainImage)
        case .darkWood:
                addFrame(frame: .darkWood, mainImage: mainImage)
        case .goldFrame:
                addFrame(frame: .goldFrame, mainImage: mainImage)
        case .lightWood:
                addFrame(frame: .lightWood, mainImage: mainImage)
        }
    }

    private func getImageDimensions(image: UIImage) -> (width: CGFloat, height: CGFloat)? {
        let imageSize = image.size
        let scale = image.scale
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return (width, height)
    }
    func setImageIndex() {
        DispatchQueue.main.async { [self] in
                changedImageUrl = allSaveimages[imageIndex].url
                updateImage()
        }
    }

    private func updateImage() {
        guard let imageURL = URL(string: changedImageUrl) else {
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                if let image =  UIImage(data: data) {
                    self.myUIImage = image
                    self.originalImage = image
                }
                self.imageDisplayed = UIImage(data: data)
            }
        }.resume()
    }

}
