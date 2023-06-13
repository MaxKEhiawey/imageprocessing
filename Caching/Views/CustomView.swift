//
//  CustomView.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 10/06/2023.
//

import SwiftUI

struct CustomView {

        // custom capsule button
    func capsuleButton(label: String, action: @escaping () -> Void) -> some View {
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
        // custom delete image button
    func deleteButton( action: @escaping () -> Void) -> some View {
        return Button(action: action) {
            Image(systemName: "trash")
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
                .background(Color("ColorDeleteButtonBG"))
                .cornerRadius(20)
                .padding(.top, 8)
                .padding(.trailing, 8)
        }
    }
        // custom loader
    func loader(size of: Double) -> some View {
        return VStack {
                ProgressView(value: 0.10)
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(of) // Adjust the scale factor as needed
                    .padding()
        }
    }
}
