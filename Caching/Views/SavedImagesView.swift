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
    let customButton = CustomButton()
    var body: some View {

            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                    ForEach(viewModel.allSaveimages, id: \.id) { savedImage in
                       // VStack {
                            NavigationLink {
                                SwitchImagesView(viewModel: viewModel, isDateIndex: true, imageIndex: viewModel.allSaveimages.firstIndex(of: savedImage) ?? 0)
                            } label: {
                                ZStack(alignment: .topTrailing) {
                                    ImageView(url: savedImage.url)
                                    customButton.deleteButton {
                                        viewModel.remove(id: savedImage.id)
                                    }
                                }
                            }
                    }
                }

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fire") {
                            apiViewModel.getImages(addImages: true)
                            print("saved ImagesCount:", viewModel.allSaveimages.count)
                    }
                }
            }
        
            .navigationBarTitle(pageTitle)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.leading, 4)
            .padding(.trailing, 4)
        }
    }
