//
//  SwitchImagesView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct SwitchImagesView: View {
    @StateObject private var viewModel = SavedImagesVM()
    @State var isOriginalImage: Bool = true
    @State private var selectedSegment = 0
    let savedImage: SavedImage
    var body: some View {
        VStack {
            Spacer()
            Picker(selection: $selectedSegment, label: Text("Switch Images")) {
                Text("Original").tag(0)
                Text("Blur").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedSegment) { newValue in
                print("SWITCH <>><>number", selectedSegment )
                switchImage()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            Image(uiImage: isOriginalImage ? savedImage.originalImage: savedImage.blurredImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
            Spacer()
        }
    }
    func switchImage() {
        print("SWITCH number", selectedSegment )
        DispatchQueue.main.async {
            switch selectedSegment {
                case 0:
                    isOriginalImage = true
                   // viewModel.update(id: savedImage.id, isShowingOriginal: isOriginalImage)
                case 1:
                    isOriginalImage = false
                   // viewModel.update(id: savedImage.id, isShowingOriginal: isOriginalImage)
                default:
                    print("Wrong number")
            }
        }

    }
}
