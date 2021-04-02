//
//  ContentView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties -
    
    @Namespace private var namespace
    @State private var showDetails: Bool = false
    
    // MARK: - Views -
    
    var body: some View {
        subviews
            .gesture(dragGesture)
    }
    
    private var subviews: some View {
        VStack {
            spacer
            if showDetails {
                musicPlayer
            } else {
                musicPlayerBar
            }
        }
    }
    
    private var spacer: some View {
        Spacer()
    }
    
    private var musicPlayer: some View {
        MusicPlayer(namespace: namespace)
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar(namespace: namespace)
            .onTapGesture(perform: onMusicPlayerBarTapGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded(onDragGestureEnded)
    }
    
    // MARK: - Methods -
    
    private func onMusicPlayerBarTapGesture() {
        withAnimation {
            showDetails.toggle()
        }
    }
    
    private func onDragGestureEnded(_ value: DragGesture.Value) {
        if value.translation.height < 0 {
            // up
            withAnimation(.spring()) {
                showDetails = true
            }
        }
        
        if value.translation.height > 0 {
            // down
            withAnimation(.spring()) {
                showDetails = false
            }
        }
    }
}

// MARK: - Previews -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
