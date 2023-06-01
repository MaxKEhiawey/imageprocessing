//
//  ImageListView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct ImageListView: View {
    static let dataservice = NetworkManager()

    var body: some View {
        ImageGridView(dataService: ImageListView.dataservice)
    }
}
