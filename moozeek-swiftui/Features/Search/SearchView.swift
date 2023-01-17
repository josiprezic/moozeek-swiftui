//
//  SearchView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    @State private var showDetails: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if Reachability.isConnected {
                    VStack {
                        Spacer()
                        pasteButton
                        Spacer()
                        title
                        description
                        Spacer()
                    }
                } else {
                    YouAreOfflineView()
                }
                musicPlayerBar
            }
        }
        .fullScreenCover(isPresented: $showDetails) { MusicPlayer.resolved }
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar.resolved
            .onTapGesture(perform: onMusicPlayerBarTapGesture)
            .gesture(dragGesture)
    }
    
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
    
    private var title: some View {
        Text(viewModel.titleText)
            .font(.title)
            .padding(.bottom, 5)
    }
    
    private var description: some View {
        Text(.init(viewModel.descriptionText))
            .font(.body)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView.resolved
    }
}
