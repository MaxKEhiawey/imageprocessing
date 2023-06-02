//  ImgFileManager.swift
//  Caching
//
//  Created by Noye Samuel on 30/03/2023.
//

import Foundation
import SwiftUI

class ImgFileManager {
    static let shared = ImgFileManager()
    let folderName = "cacheImg"
    
    private init() {
        createFolderIfNeeded()
    }
    
    private func createFolderIfNeeded() {
        guard let url = getFolderPath() else { return}
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try
                FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("created folder")
                } catch let error {
                print("error creating folder", error)
            }
        }
    }
    
    private func getFolderPath() -> URL? {
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key: String) -> URL? {
        guard let folder = getFolderPath() else {
            return nil
        }
        return folder.appendingPathComponent(key + ".png")
    }
    
    func add(key: String, image: UIImage) {
        guard
            let data = image.pngData(),
                let url = getImagePath(key: key) else { return }
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving to file manager", error)
        }
     }
     
    func get(key: String) -> UIImage? {
        guard
               let url = getImagePath(key: key),
               FileManager.default.fileExists(atPath: url.path) else {
               return nil
        }
        print("got from folder")
        return UIImage(contentsOfFile: url.path)
    }
}
