    //
    //  ImageDetailView.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 30/05/2023.
    //

import SwiftUI
import UIKit

struct ImageDetailView: View {
    @State private var index = 0
    @State private var changedImage = ""
    @State private var image: UIImage? = nil
    var imageList: [UnsplashImage]
    @State var key: String
    
    init(imageList: [UnsplashImage], key: String) {
        self.imageList = imageList
        self.key = key
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
                }
            }
            .frame(height: 200)
            .padding(.all, 4)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width < 0 {
                            changeindex(value: 1)
                            
                        } else if gesture.translation.width > 0 {
                            changeindex(value: -1)
                        }
                    }
            )
            Spacer()
            
        }
        .onAppear{
            DispatchQueue.main.async {
                setImageIndex()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EditImageView(imageUrl: changedImage, key: imageList[index].id)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
    func setImageIndex(){
        DispatchQueue.main.async {
            for (index, image) in imageList.enumerated() {
                if image.id == key {
                    self.index = index
                    changedImage = imageList[index].urls.regular
                    updateImage()
                }
            }
        }
    }
    
    func updateImage() {
        guard let imageURL = URL(string: changedImage) else {
            return
        }
        URLSession.shared.dataTask(with: imageURL) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
    func changeindex(value: Int) {
        DispatchQueue.main.async {
            if value < 0 && index > 0  {
                
                index = index + value
                print("Index:", index)
                changedImage = imageList[index].urls.regular
                self.key = imageList[index].id
                updateImage()
                
            } else if value > 0 && index < imageList.count - 1  {
                index = index + value
                print("Index:", index)
                changedImage = imageList[index].urls.regular
                self.key = imageList[index].id
                updateImage()
                
            }
        }
    }
}
