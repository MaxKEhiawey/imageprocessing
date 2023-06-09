//
    //  ImageDetailView.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 30/05/2023.
    //

import SwiftUI
import UIKit

struct ImageDetailView: View {
    @ObservedObject var viewModel: ImageViewModel
    @State var key: String
    @State private var currentPage = 0
    var body: some View {

        PagerView(pageCount: viewModel.images.count, currentIndex: $viewModel.imageIndex) {
                ForEach((0..<viewModel.images.count), id: \.self) { index in
                    VStack {
                        ImageView(url: viewModel.images[index].urls.thumb)
                    }
                }
            }

        .onAppear {
            DispatchQueue.main.async {
                viewModel.selectedImagekey = key
                viewModel.setImageIndex()

           }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                   // EditImageView(viewModel: viewModel)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}
