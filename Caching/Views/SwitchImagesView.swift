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
            Image(uiImage: viewModel[index].processedImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
            Spacer()
        }
        .offset(x: isSwipedLeft ? 20 : isSwipedRight ? -20 : 0)
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
}
