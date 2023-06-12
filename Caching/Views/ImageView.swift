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
                if let url = URL(string: url) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(height: 240) // Adjust the width and height as needed
                    } placeholder: {
                    // Placeholder view or activity indicator while loading
                        CustomView().loader(size: 1.0)
                    }
                } else {
                    CustomView().loader(size: 2.0)
                }
            }
            .padding(.all, 4)
        }
    }
