//
//  AirPlayButton.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 02/08/2024.
//

import SwiftUI
import AVKit

/// A SwiftUI view that wraps an `AVRoutePickerView` to provide an AirPlay button
struct AirPlayButton: UIViewRepresentable {
    
    /// Creates the `AVRoutePickerView` to be used as the AirPlay button
    /// - Parameter context: The context in which the view is being created
    /// - Returns: A configured `AVRoutePickerView`
    func makeUIView(context: Context) -> AVRoutePickerView {
        AVRoutePickerView()
    }
    
    /// Updates the state of the specified view with new information from SwiftUI
    /// - Parameters:
    ///   - uiView: The `AVRoutePickerView` to update
    ///   - context: The context in which the view is being updated
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        // No need to update the view in this case, as the AVRoutePickerView does not require updates
    }
}
