//
//  SavedImagesView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct SavedImagesView: View {
    @StateObject private var viewModel = SavedImagesVM()
    @ObservedObject  var apiViewModel = ImageViewModel(dataService: NetworkManager())
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
    @State var pageTitle: String = "Saved images"
    let customView = CustomView()
    var body: some View {

        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                ForEach(viewModel.allSaveimages, id: \.id) { savedImage in
                        // VStack {
                    NavigationLink(destination: SwitchImagesView(viewModel: viewModel, isDateIndex: true, imageIndex: viewModel.allSaveimages.firstIndex(of: savedImage) ?? 0)) {
                        ZStack(alignment: .topTrailing) {
                            ImageView(url: savedImage.url)
                                .onAppear {
                                    if viewModel.allSaveimages.count == (viewModel.allSaveimages.firstIndex(of: savedImage) ?? 0) + 1 {
                                          apiViewModel.getImages(addImages: true)
                                    }
                                }
                            customView.deleteButton {
                                viewModel.remove(id: savedImage.id)
                            }
                        }
                    }
                }
            }
         if apiViewModel.isLoading {
            customView.loader(size: 2.0)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Fetch") {
                    apiViewModel.getImages(addImages: true)
                }
                .onAppear {
                    if viewModel.allSaveimages.isEmpty {
                        apiViewModel.getImages(addImages: true)
                    }
                }
            }
        }
        .navigationBarTitle(pageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.leading, 4)
        .padding(.trailing, 4)
    }
}
