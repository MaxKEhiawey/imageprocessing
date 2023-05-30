//
//  ImageDetailView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct ImageDetailView: View {
    @StateObject var imageLoader: ImageLoaderVM
    var url: String
    var key: String
    init(imageUrl: String, key: String) {
        self.url = imageUrl
        self.key = key
        _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!, key: key))
    }

    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EditImageView(imageUrl: url, key: key)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}
