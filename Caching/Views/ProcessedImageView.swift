//
    //  ProcessedImageView.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 30/05/2023.
    //

import SwiftUI
import UIKit

struct ProcessedImageView: View {
    @StateObject private var viewModel = SavedImagesVM()
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible())]
    let customButton = CustomButton()
    @State private var currentPage = 0
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                ForEach((0..<viewModel.processedImages.count), id: \.self) { index in
                    NavigationLink(destination: Text("")) {

                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: viewModel.processedImages[index].processedImage)
                                .resizable()
                                .frame(height: 200)
                            customButton.deleteButton {
                                viewModel.removeProcessed(id: viewModel.processedImages[index].id)
                            }
                        }
                    }
                }
            }
        }.onAppear {
            viewModel.fetchProcessedImages()
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .navigationBarTitle("Processed Images")
    }
}
