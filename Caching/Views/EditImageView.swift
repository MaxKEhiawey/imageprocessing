//
    //  EditImageView.swift
    //  Caching
    //
    //  Created by AMALITECH MACBOOK on 25/05/2023.
    //

import SwiftUI
import CoreImage

struct EditImageView: View {

    @StateObject var imageLoader: ImageLoaderVM
    @State var isGoingBack: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var processMethod = ImageEditingMethods()
    @StateObject var savedImagesViewModel = SavedImagesVM()
    @State private var play: Bool = false
    init(imageUrl: String, key: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!, key: key))
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                
                        createCapsuleButton(label: "Blur image -") {
                            processMethod.blurRadius-=1.0
                            processMethod.processImage(processType: .blurImage, originalImage: imageLoader.image)
                        }
                        createCapsuleButton(label: "Blur image +") {
                            processMethod.blurRadius+=1.0
                            processMethod.processImage(processType: .blurImage, originalImage: imageLoader.image)
                        }

                        //: Frames
                        Menu(content: {
                            createCapsuleButton(label: "BlackFrame") {
                                processMethod.processImage(processType: .addFrame(type: .blackFrame), originalImage: imageLoader.image)
                            }
                            createCapsuleButton(label: "DarkWoodFrame") {
                                processMethod.processImage(processType: .addFrame(type: .darkWood), originalImage: imageLoader.image)
                            }
                            createCapsuleButton(label: "GoldFrame") {
                                processMethod.processImage(processType: .addFrame(type: .goldFrame), originalImage: imageLoader.image)
                            }
                            createCapsuleButton(label: "LightWoodFrame") {
                                processMethod.processImage(processType: .addFrame(type: .lightWood), originalImage: imageLoader.image)
                            }}, label: {
                                createCapsuleButton(label: "Select a frame") {}
                            })
                        //: orientation
                        Menu(content: {
                            createCapsuleButton(label: "Portrait") {
                                processMethod.processImage(processType: .orientation(orientation: .up), originalImage: imageLoader.image)
                            }
                            createCapsuleButton(label: "Portrait Mirrored") {
                                processMethod.processImage(processType: .orientation(orientation: .upMirrored), originalImage: imageLoader.image)
                            }
                            createCapsuleButton(label: "Portrait Capside") {
                                processMethod.processImage(processType: .orientation(orientation: .downMirrored), originalImage: imageLoader.image)
                            }
                            createCapsuleButton(label: "Left Landscape") {
                                processMethod.processImage(processType: .orientation(orientation: .leftMirrored), originalImage: imageLoader.image)
                            }
                            createCapsuleButton(label: "Right Landscape") {
                                processMethod.processImage(processType: .orientation(orientation: .rightMirrored), originalImage: imageLoader.image)
                            }
                        }, label: {
                            createCapsuleButton(label: "Select Orient") {}
                        })

                        createCapsuleButton(label: "Zoom image -") {
                            guard processMethod.zoomScale > 0.01501 else {return}
                            processMethod.zoomScale -= 0.01
                            processMethod.processImage(processType: .zoomImage, originalImage: imageLoader.image)
                        }

                        createCapsuleButton(label: "Zoom image +") {
                            processMethod.zoomScale += 0.01
                            processMethod.processImage(processType: .zoomImage, originalImage: imageLoader.image)
                        }
                    }
                }
                .padding()
                //: Image in View
                Image(uiImage: processMethod.myUIImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(height: 400)
                    .padding()
                //: Button to revert to original image
                HStack {
                    createCapsuleButton(label: "Revert to Original") {
                        processMethod.processImage(processType: .originalImage, originalImage: imageLoader.image)
                    }
                //: Button to save
                    createCapsuleButton(label: "Save Image") {
                     processMethod.processImage(processType: .saveImage, originalImage: imageLoader.image)
                        play = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                              isGoingBack = true
                        }
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
            .navigationDestination(isPresented: $isGoingBack) {
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
                if let activeImage = imageLoader.image {
                    processMethod.myUIImage = activeImage
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
