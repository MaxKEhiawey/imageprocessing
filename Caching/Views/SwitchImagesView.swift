//
    //  SwitchImagesView.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 30/05/2023.
    //

import SwiftUI

struct SwitchImagesView: View {
    @ObservedObject var viewModel: SavedImagesVM
    @ObservedObject  var apiViewModel = ImageViewModel(dataService: NetworkManager())
    @State var isDateIndex: Bool = false
    @State var imageIndex: Int = 0
    var body: some View {
        VStack {
            Spacer()
            PagerView(pageCount: viewModel.allSaveimages.count, currentIndex: $viewModel.imageIndex) {
                ForEach((0..<viewModel.allSaveimages.count), id: \.self) { index in

                        ImageView(url: viewModel.allSaveimages[index].url)
                        .padding(.top, 16)
                }
            }
            Spacer()
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .onAppear {
            DispatchQueue.main.async {
              if isDateIndex {
                    viewModel.imageIndex = imageIndex
                  isDateIndex = false
                }

            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EditImageView(viewModel: viewModel)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}
