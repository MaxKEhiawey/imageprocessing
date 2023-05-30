//
//  EditImageView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 25/05/2023.
//

import SwiftUI
import CoreImage

struct EditImageView: View {
    @StateObject var imageLoader: ImageLoaderVM
    @State var isImageBlurred: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var savedImagesViewModel = SavedImagesVM()
    init(imageUrl: String, key: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!, key: key))
    }
    @State var myUIImage: UIImage = UIImage(systemName: "photo")!
    var imgUtility = ImageUtilities()
    var body: some View {
        VStack {
            Spacer()

                Image(uiImage: myUIImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(height: 400)
                    .padding()
            Button(action: {
                processImage()
                if isImageBlurred {
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text(isImageBlurred ? "Save Image": "Blur Image")
            })

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                  SavedImagesView()
                } label: {
                    Text("Saved Images")
                }
            }
        }
        .onAppear {
            if let activeImage = imageLoader.image {
                self.myUIImage = activeImage
            }
        }
        .navigationTitle("Edit Image")
    }
    private func processImage() {
        if let activeImage = imageLoader.image {
            DispatchQueue.global().async {
                let blurredImage = imgUtility.gaussianBlur(image: activeImage, blurRadius: 10.0)
                DispatchQueue.main.async {
                    myUIImage = blurredImage
                }
                if isImageBlurred {
                    savedImagesViewModel.saveImage( blurredImage: blurredImage, originalImage: activeImage)

                } else {
                    isImageBlurred = true
                }
            }
        }
    }
}
