//
//  ImageListView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct ImageListView: View {
    var body: some View {
        ImageGridView(viewModel: ImageViewModel(dataService: NetworkManager()))
    }
}
