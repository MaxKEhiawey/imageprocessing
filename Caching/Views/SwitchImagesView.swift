//
//  SwitchImagesView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 30/05/2023.
//

import SwiftUI

struct SwitchImagesView: View {
    var viewModel: [SavedImage]
    @State private var isSwipedLeft = false
    @State private var isSwipedRight = false
    @State var isOriginalImage: Bool = true
    @State private var selectedSegment = 0
    @State private var index = 0
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
            Image(uiImage: isOriginalImage ? viewModel[index].originalImage: viewModel[index].blurredImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
            Spacer()
        }
        .offset(x: isSwipedLeft ? 200 : isSwipedRight ? -200 : 0)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width < 0 {

                        handleSwipeRight()
                    } else if gesture.translation.width > 0 {
                        handleSwipeLeft()
                    }
                }
        )
        .onAppear {
            for (index, number) in viewModel.enumerated() {
                if number.id == savedImage.id {
                    self.index = index
                }
            }



        }
    }
    func handleSwipeLeft() {
        if index > 0 {
            withAnimation {
                isSwipedLeft = true
            }
                // Perform other actions for swipe left
            print("Swiped left")

                // Reset state after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isSwipedLeft = false
                    if index > 0 {
                        index = index - 1
                        print( "Left Index: \(index)")
                    }
                }
            }
        }
    }
    func handleSwipeRight() {
            // Swiped right
        let limit = viewModel.count-1
        if index < limit {
        withAnimation {
            isSwipedRight = true
        }
            // Perform other actions for swipe right
        print("Swiped right")

            // Reset state after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isSwipedRight = false
                    // Swiped right
                    index = index + 1
                    print( "right Index: \(index)")
                }
            }
        }
    }
    func switchImage() {
        print("SWITCH number", selectedSegment )
        DispatchQueue.main.async {
            switch selectedSegment {
                case 0:
                    isOriginalImage = true
                case 1:
                    isOriginalImage = false
                default:
                    print("Wrong number")
            }
        }

    }
}
