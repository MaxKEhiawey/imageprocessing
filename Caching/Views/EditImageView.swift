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
    init(imageUrl: String, key: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!, key: key))
    }

    var body: some View {

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
                     guard processMethod.zoomScale > 0.0101 else {return}
                        processMethod.zoomScale -= 0.01
                        processMethod.processImage(processType: .zoomImage, originalImage: imageLoader.image)
                        print("zoomscale is:", processMethod.zoomScale)
                    }

                    createCapsuleButton(label: "Zoom image +") {
                       // guard zoomScale > 0 else {return}
                        processMethod.zoomScale += 0.01
                        processMethod.processImage(processType: .zoomImage, originalImage: imageLoader.image)
                        print("zoomscale is:", processMethod.zoomScale)
                    }
                }
            }

            Image(uiImage: processMethod.myUIImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()

//            Slider(value: $processMethod.zoomScale, in: -3.0...3.0, step: 0.05, onEditingChanged: { editing in
//                    // Perform action when slider value changes
//                processMethod.processImage(processType: .zoomImage, originalImage: imageLoader.image)
//                if editing &&  processMethod.zoomScale > 1.0 {
//                        //  processImage(processType: .zoomImage)
//                        // Slider value is being edited
//                    print("Slider value editing started")
//                } else {
//                        // Slider value editing finished
//                    print("Slider value editing finished")
//                }
//            })
//            .padding()

            HStack {
                createCapsuleButton(label: "Revert to Original") {
                    processMethod.processImage(processType: .originalImage, originalImage: imageLoader.image)
                }
                createCapsuleButton(label: "Save Image") {
                    processMethod.processImage(processType: .saveImage, originalImage: imageLoader.image)
                    isGoingBack = true
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
