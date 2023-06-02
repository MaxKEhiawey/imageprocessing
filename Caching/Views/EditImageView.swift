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
    @StateObject private var savedImagesViewModel = SavedImagesVM()
    @State private var zoomScale: CGFloat = 1.0
    @State var myUIImage: UIImage = UIImage(systemName: "photo")!
    var imgUtility = ImageUtilities()

    init(imageUrl: String, key: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!, key: key))
    }

    var body: some View {

        VStack {
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {

                    createCapsuleButton(label: "Blur image") {
                        processImage(processType: .blurImage)
                    }

                    Menu(content: {
                        Button(action: {
                            processImage(processType: .addFrame(type: .blackFrame))
                        }, label:  {
                            Text("BlackFrame")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .addFrame(type: .darkWood))
                        }, label:  {
                            Text("DarkWoodFrame")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .addFrame(type: .goldFrame))
                        }, label:  {
                            Text("GoldFrame")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .addFrame(type: .lightWood))
                        }, label:  {
                            Text("LightWoodFrame")
                                .foregroundColor(.blue)
                        })
                    }) {
                        Button(action: {

                        }, label:  {
                            Text("Select a frame")
                                .frame(height: 10)
                                .padding(8)
                                .foregroundColor(.white)
                                .background(
                                    Capsule()
                                        .fill(Color.blue)
                                )
                        })
                    }

                    Menu(content: {
                        Button(action: {
                            processImage(processType: .orientation(orientation: .up))
                        }, label:  {
                            Text("Up")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .orientation(orientation: .down))
                        }, label:  {
                            Text("Down")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .orientation(orientation: .left))
                        }, label:  {
                            Text("Left")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .orientation(orientation: .right))
                        }, label:  {
                            Text("Right")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .orientation(orientation: .upMirrored))
                        }, label:  {
                            Text("Up Mirrored")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .orientation(orientation: .downMirrored))
                        }, label:  {
                            Text("Down Mirrored")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .orientation(orientation: .leftMirrored))
                        }, label:  {
                            Text("Left Mirrored")
                                .foregroundColor(.blue)
                        })
                        Button(action: {
                            processImage(processType: .orientation(orientation: .rightMirrored))
                        }, label:  {
                            Text("Right Mirrored")
                                .foregroundColor(.blue)
                        })
                    }) {
                        Button(action: {

                        }, label:  {
                            Text("Select Orient")
                                .frame(height: 10)
                                .padding(8)
                                .foregroundColor(.white)
                                .background(
                                    Capsule()
                                        .fill(Color.blue)
                                )
                        })
                    }
                    createCapsuleButton(label: "Zoom image 1") {
                        guard zoomScale > 0 else {return}
                        zoomScale += 1
                        if let zoomedImage = imgUtility.applyZoomEffect(image: myUIImage, zoomScale: zoomScale) {
                            myUIImage = zoomedImage
                        }
                    }
                    createCapsuleButton(label: "Zoom image 2") {
                        guard zoomScale > 0 else {return}
                        zoomScale -= 1
                        if let zoomedImage = imgUtility.applyZoomEffect(image: myUIImage, zoomScale: zoomScale) {
                            myUIImage = zoomedImage
                        }
                    }
                }
            }
            Image(uiImage: myUIImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
            Slider(value: $zoomScale, in: 0.1...5.0, step: 0.05, onEditingChanged: { editing in
                    // Perform action when slider value changes

                if editing && zoomScale > 1.0 {
                        //  processImage(processType: .zoomImage)
                        // Slider value is being edited
                    print("Slider value editing started")
                } else {
                        // Slider value editing finished
                    print("Slider value editing finished")
                }
            })
            .padding()

            HStack {
                createCapsuleButton(label: "Revert to Original") {
                    processImage(processType: .originalImage)
                }
                createCapsuleButton(label: "Save Image") {
                    processImage(processType: .saveImage)
                        //presentationMode.wrappedValue.dismiss()
                    isGoingBack = true
                }
                .padding(.horizontal, 20)
            }
            Spacer()
        }
        .navigationDestination(isPresented: $isGoingBack) {
            SavedImagesView(pageTitle: "")
                //TabsView(selectedTab: 1)
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
                self.myUIImage = activeImage
            }
        }
        .navigationTitle("Edit Image")

    }

    func processImage(processType: ImageProcessings) {
        if let activeImage = imageLoader.image {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    switch processType {
                        case .addFrame(type: let type):
                            selectFrame(type)
                        case .blurImage:
                            if let imageBlur = imgUtility.applyBlurToImage(activeImage, withRadius: 10.0) {
                                myUIImage = imageBlur
                            }
                        case .orientation(orientation: let orientation):
                            selectOrientation(orientation, activeImage)
                        case .originalImage:
                            myUIImage = activeImage
                        case .zoomImage:
                            if let zoomedImage = imgUtility.applyZoomEffect(image: activeImage, zoomScale: zoomScale) {
                                myUIImage = zoomedImage
                            }
                        case .saveImage:
                            savedImagesViewModel.saveImage(processedImage: myUIImage)


                    }
                }
            }
        }
    }
    func addFrame(frame: Frames) {
        var width = 0.0
        var height = 0.0

        if let dimensions = getImageDimensions(image: myUIImage) {
            width = dimensions.width
            height = dimensions.height
            print("Image dimensions: \(width) x \(height)")
        } else {
            print("Failed to retrieve image dimensions")
        }
        let frameSize = CGSize(width: width, height: height)
        if let frameImage = UIImage(named: frame.rawValue) {
            if let selectedFrame = imgUtility.addImageFrame(to: myUIImage, frameImage: frameImage, frameSize: frameSize) {
                myUIImage = selectedFrame
            }
        }
    }

    func selectFrame(_ type: Frames) {
        switch type {
            case .blackFrame:
                addFrame(frame: .blackFrame)
            case .darkWood:
                addFrame(frame: .darkWood)
            case .goldFrame:
                addFrame(frame: .goldFrame)
            case .lightWood:
                addFrame(frame: .lightWood)
        }
    }
    func selectOrientation(_ orientation: UIImage.Orientation, _ image: UIImage) {
        switch orientation {
            case .left:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .left) {
                    myUIImage = transformedImage
                }
            case .up:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .up) {
                    myUIImage = transformedImage
                }
            case .down:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .down) {
                    myUIImage = transformedImage
                }
            case .right:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .right) {
                    myUIImage = transformedImage
                }
            case .upMirrored:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .upMirrored) {
                    myUIImage = transformedImage
                }
            case .downMirrored:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .downMirrored) {
                    myUIImage = transformedImage
                }
            case .leftMirrored:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .leftMirrored) {
                    myUIImage = transformedImage
                }
            case .rightMirrored:
                if let transformedImage = imgUtility.rotationImage(image: image, rotation: .rightMirrored) {
                    myUIImage = transformedImage
                }
            @unknown default:
                print("Unknown move")
        }

    }
    func getImageDimensions(image: UIImage) -> (width: CGFloat, height: CGFloat)? {
        let imageSize = image.size
        let scale = image.scale
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return (width, height)
    }

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
enum ImageProcessings {
    case addFrame(type: Frames)
    case blurImage
    case orientation(orientation: UIImage.Orientation)
    case originalImage
    case zoomImage
    case saveImage

}

enum Frames: String {
    case blackFrame = "BlackFrame"
    case darkWood = "DarkWoodFrame"
    case goldFrame = "GoldFrame"
    case lightWood = "LightWoodFrame"
}
