//
//  SearchView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import SwiftUI

/// A view that provides a search interface with connectivity status and a music player bar
struct SearchView: View {
    /// The view model that manages the state and actions for the search view
    @StateObject var viewModel: SearchViewModel
    
    /// A state variable to control the presentation of the music player details
    @State private var showDetails: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Check if the device is connected to the internet
                if Reachability.isConnected {
                    contentView
                } else {
                    YouAreOfflineView()
                }
                musicPlayerBar
            }
        }
        // Present the music player in full screen when `showDetails` is true
        .fullScreenCover(isPresented: $showDetails) { MusicPlayer.resolved }
    }
    
    /// The main content view when the device is online
    private var contentView: some View {
        VStack {
            Spacer()
            pasteButton
            Spacer()
            title
            description
            Spacer()
        }
    }
    
    /// A button that allows the user to paste content
    private var pasteButton: some View {
        Button(
            action: viewModel.handlePasteSelected,
            label: {
                HStack {
                    Text("Paste")
                    Image(systemName: "doc.on.clipboard.fill")
                }
                .font(.system(size: 50))
                .padding(20)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        )
    }
    
    /// The title text for the search view
    private var title: some View {
        Text(viewModel.titleText)
            .font(.title)
            .padding(.bottom, 5)
    }
    
    /// The description text for the search view
    private var description: some View {
        Text(.init(viewModel.descriptionText))
            .font(.body)
    }
    
    /// A bar that displays the music player and allows interaction with it
    private var musicPlayerBar: some View {
        MusicPlayerBar.resolved
            .onTapGesture(perform: onMusicPlayerBarTapGesture)
            .gesture(dragGesture)
    }
    
    // MARK: - Gestures
    
    /// A drag gesture to handle the interaction with the music player bar
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded(onDragGestureEnded)
    }
    
    /// Handles the tap gesture on the music player bar
    private func onMusicPlayerBarTapGesture() {
        withAnimation {
            showDetails.toggle()
        }
    }
    
    /// Handles the end of the drag gesture on the music player bar
    /// - Parameter value: The value of the drag gesture
    private func onDragGestureEnded(_ value: DragGesture.Value) {
        if value.translation.height < 20 {
            showDetails = true
        } else if value.translation.height > 60 {
            showDetails = false
        }
    }
}

/// A preview provider for `SearchView` to enable live preview in Xcode
struct SearchView_Previews: PreviewProvider {
    /// Previews the `SearchView` for SwiftUI canvas
    static var previews: some View {
        SearchView.resolved
    }
}
