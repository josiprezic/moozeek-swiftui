//
//  RadioView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/01/2023.
//

import SwiftUI

struct RadioView: View {
    @StateObject var viewModel: RadioViewModel
    
    @State private var showDetails: Bool = false
    
    let collectionLeadingOffset: CGFloat = 15.0
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isOnline {
                    contentView
                } else {
                    offlineView
                }
                musicPlayerBar
            }
            .navigationTitle("Radio")
        }
        .fullScreenCover(isPresented: $showDetails) { MusicPlayer.resolved }
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ExclusiveRadioSection(radioList: viewModel.exclusiveSection)
                BroadcastRadioSection(title: "Local Broadcasters", radioSections: viewModel.localBroadcasterSections)
                BroadcastRadioSection(title: "International Broadcasters", radioSections: viewModel.internationalBroadcasterSections)
            }
        }
        .padding(.bottom, -8)
    }
    
    private var offlineView: some View {
        YouAreOfflineView()
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar.resolved
            .onTapGesture(perform: onMusicPlayerBarTapGesture)
            .gesture(dragGesture)
    }
    
    // MARK: - Drag gesture
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded(onDragGestureEnded)
    }
    
    private func onMusicPlayerBarTapGesture() {
        withAnimation {
            showDetails.toggle()
        }
    }
    
    private func onDragGestureEnded(_ value: DragGesture.Value) {
        if value.translation.height < 20 {
            showDetails = true
        } else if value.translation.height > 60 {
            showDetails = false
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView.resolved
    }
}
