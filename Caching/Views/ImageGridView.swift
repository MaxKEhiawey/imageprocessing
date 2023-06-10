//
//  ImageGridView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI

struct ImageGridView: View {
    
    @StateObject var viewModel: ImageViewModel
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
  
    var body: some View {
       
        NavigationView {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                            ForEach((0..<viewModel.images.count), id: \.self) { index in
                                NavigationLink(destination: Text("")) {
                                    ImageView(url: viewModel.images[index].urls.thumb)
                        }
                    }
                }
            }.padding(.leading, 4)
                    .padding(.trailing, 4)
                    .navigationBarTitle("Unsplash Images")
            }
        }
    }
}
