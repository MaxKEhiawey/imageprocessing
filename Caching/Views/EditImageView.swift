//
    //  EditImageView.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 25/05/2023.
    //

import SwiftUI
import CoreImage

struct EditImageView: View {
    @State var isSaved: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject  var viewModel: SavedImagesVM
    @State private var play: Bool = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                
                        createCapsuleButton(label: "Blur image -") {
                            viewModel.blurRadius-=1.0
                            viewModel.processImage(processType: .blurImage)
                        }
                        createCapsuleButton(label: "Blur image +") {
                            viewModel.blurRadius+=1.0
                            viewModel.processImage(processType: .blurImage)
                        }

                        //: Frames
                        Menu(content: {
                            createCapsuleButton(label: "BlackFrame") {
                                DispatchQueue.main.async {
                                    viewModel.processImage(processType: .addFrame(type: .blackFrame))

                                }
                            }
                            createCapsuleButton(label: "DarkWoodFrame") {
                                viewModel.processImage(processType: .addFrame(type: .darkWood))
                            }
                            createCapsuleButton(label: "GoldFrame") {
                                viewModel.processImage(processType: .addFrame(type: .goldFrame))
                            }
                            createCapsuleButton(label: "LightWoodFrame") {
                                viewModel.processImage(processType: .addFrame(type: .lightWood))
                            }}, label: {
                                createCapsuleButton(label: "Select a frame") {}
                            })
                        //: orientation
                        Menu(content: {
                            createCapsuleButton(label: "Portrait") {
                                viewModel.processImage(processType: .orientation(isLeftLandscape: false, isPortrait: true))
                            }

                            createCapsuleButton(label: "Right Landscape") {
                                viewModel.processImage(processType: .orientation(isLeftLandscape: false, isPortrait: false))
                            }
                            createCapsuleButton(label: "Left Landscape") {
                                viewModel.processImage(processType: .orientation(isLeftLandscape: true, isPortrait: false))
                            }
                        }, label: {
                            createCapsuleButton(label: "Select Orient") {}
                        })

                        createCapsuleButton(label: "Zoom image -") {
                            guard   viewModel.zoomScale > 0.01501 else {return}
                            viewModel.zoomScale -= 0.01
                            viewModel.processImage(processType: .zoomImage)
                        }

                        createCapsuleButton(label: "Zoom image +") {
                            viewModel.zoomScale += 0.01
                            viewModel.processImage(processType: .zoomImage)
                        }
                    }
                }
                .padding()
                //: Image in View
                Image(uiImage: viewModel.myUIImage)
                    .resizable()
                    .frame(height: 400)
                    .padding()
                //: Button to revert to original image
                HStack {
                    createCapsuleButton(label: "Revert to Original") {
                        viewModel.processImage(processType: .originalImage)
                    }
                //: Button to save
                    createCapsuleButton(label: "Save Image") {
                        viewModel.processImage(processType: .saveImage)
                        play = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                              isSaved = true
                        }
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
            .navigationDestination(isPresented: $isSaved) {
                SavedImagesView(pageTitle: "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SavedImagesView(pageTitle: "")
                    } label: {
                        Text("Saved Images")
                    }
                }
            }
            .onAppear {
                viewModel.setImageIndex()
                if let activeImage = viewModel.imageDisplayed {
                    viewModel.myUIImage = activeImage
                    viewModel.originalImage = activeImage
                }
            }
            .navigationTitle("Edit Image")
            LottiePlusView(name: Constants.confetti,
                           animationSpeed: 1.5,
                           contentMode: .scaleAspectFill,
                           play: $play)
            .id(play)
            .allowsHitTesting(false)
            LottiePlusView(name: Constants.success,
                           animationSpeed: 1.5,
                           contentMode: .scaleAspectFill,
                           play: $play)
            .frame(width: 160, height: 160)
            .id(play)
            .allowsHitTesting(false)
        }.ignoresSafeArea()
    }
// custom button
    func createCapsuleButton(label: String, action: @escaping () -> Void) -> some View {
        return Button(action: action) {
            Text(label)
                .frame(height: 10)
                .padding(8)
                .foregroundColor(.white)
                .background(
                    Capsule()
                        .fill(Color.blue)
                )
        }
    }

}
