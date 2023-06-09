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
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                    ForEach(viewModel.allSaveimages, id: \.id) { savedImage in
                        VStack {
                            NavigationLink {
                                SwitchImagesView(viewModel: viewModel, isDateIndex: true, imageIndex: viewModel.allSaveimages.firstIndex(of: savedImage) ?? 0)
                            } label: {
                                ZStack(alignment: .topTrailing) {
                                    ImageView(url: savedImage.url)
                                    Button(action: {
                                        viewModel.remove(id: savedImage.id)
                                    }, label: {
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
                        .onAppear {
                            print("saved ImagesCount:", viewModel.allSaveimages.count)

                            }
                        .frame(height: 200)
                        .padding(.all, 4)
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
            .padding(.leading, 4)
            .padding(.trailing, 4)
        }
    }
}
