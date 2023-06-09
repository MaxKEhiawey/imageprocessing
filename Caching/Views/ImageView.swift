//
//  ImageView.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import SwiftUI

    struct ImageView: View {
        @State var url: String
        @State var imageDisplay: UIImage?
        var body: some View {
            VStack {
                if let imageDisplay {
                    Image(uiImage: imageDisplay)
                        .resizable()
                } else {
                    ProgressView()
                }
            }

            .onAppear {
                updateImage()
            }
            .frame(height: 300)
            .padding(.all, 4)
        }
        private func updateImage() {

            guard let imageURL = URL(string: url) else {
                return
            }
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.imageDisplay = UIImage(data: data)
                }
            }.resume()
        }
    }
