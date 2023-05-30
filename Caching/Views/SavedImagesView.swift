//
//  SavedImagesView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct SavedImagesView: View {
    @StateObject private var viewModel = SavedImagesVM()
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                ForEach(viewModel.allSaveimages, id: \.id) { savedImage in
                   VStack {
                       NavigationLink {
                           SwitchImagesView(viewModel: viewModel.allSaveimages, savedImage: savedImage)
                       } label: {
                           ZStack(alignment: .topTrailing) {
                               Image(uiImage: savedImage.isShowingOriginal ? savedImage.originalImage: savedImage.blurredImage)
                                   .resizable()
                               Button(action: {
                                   viewModel.remove(id: savedImage.id)
                               }, label:  {
                                   Image(systemName: "trash")
                                       .frame(width: 30, height: 30)
                                       .foregroundColor(.red)
                                       .background(Color.gray)
                                       .cornerRadius(20)
                                       .padding(.top, 8)
                                       .padding(.trailing, 8)
                               })
                           }
                       }
                    }
                    .frame(height: 200)
                    .padding(.all, 4)
                }
            }

        }
        .onAppear {

        }
        .padding(.leading, 4)
        .padding(.trailing, 4)
    }
}

