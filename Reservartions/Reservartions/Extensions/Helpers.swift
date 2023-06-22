//
//  Helpers.swift
//  Reservartions
//
//  Created by HHS on 10/09/2022.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct dataBaseFields{
    static let id = "id"
    static let name = "name"
    static let startHour = "startHour"
    static let endHour = "endHour"
    static let date = "date"
}

// ACTIVITY INDICATOR

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var shouldAnimate: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

