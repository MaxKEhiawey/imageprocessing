//
//  TabsView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct TabsView: View {
    @State  var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            ImageListView()
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)

            SavedImagesView()
            .tabItem {
                Image(systemName: "photo")
                Text("Saved images")
            }
            .tag(1)
    }
    .navigationBarBackButtonHidden(true)
    }
}
