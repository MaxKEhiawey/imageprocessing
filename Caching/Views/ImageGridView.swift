//
//  ImageGridView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI

struct ImageGridView: View {
    
    @StateObject private var viewModel: ViewModel
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
    
    init(dataService: NetworkManager) {
        _viewModel = StateObject(wrappedValue: ViewModel(dataService: dataService))
    }
    
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
                                NavigationLink(destination: ImageDetailView(imageUrl: viewModel.images[index].urls.thumb, key: viewModel.images[index].id)) {
                            ImageView(imageUrl: viewModel.images[index].urls.regular, key: viewModel.images[index].id)
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

struct ImageGridView_Previews: PreviewProvider {
    static let dataService = NetworkManager()
    static var previews: some View {
        ImageGridView(dataService: dataService)
    }
}
