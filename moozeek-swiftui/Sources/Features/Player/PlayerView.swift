//
//  PlayerView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 4/2/21.
//

import SwiftUI

struct PlayerView: View {
    
    // MARK: - Properties -
    
    @Namespace private var namespace
    @State private var showDetails: Bool = false
    @ObservedObject var viewModel: PlayerViewModel
    
    // MARK: - Views -
    
    var body: some View {
        subviews
    }
    
    private var subviews: some View {
        ZStack {
            trackList
            musicPlayer
        }
    }
    
    private var musicPlayer: some View {
        VStack {
            if showDetails {
                musicPlayerDetail
            } else {
                spacer
                musicPlayerBar
            }
        }
        .gesture(dragGesture)
    }
    
    private var spacer: some View {
        Spacer()
    }
    
    private var musicPlayerDetail: some View {
        MusicPlayer(namespace: namespace)
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar(namespace: namespace)
            .onTapGesture(perform: onMusicPlayerBarTapGesture)
    }
    
    private var trackList: some View {
        List(viewModel.testTracks, rowContent: trackCell)
            .padding(.bottom, Style.Size.playerBarHeight)
    }
    
    private func trackCell(track: Track) -> some View {
        VStack {
            Text(track.title)
                .font(.system(size: 20))
            Text(track.id.uuidString.prefix(10))
                .font(.system(size: 15))
        }
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

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(viewModel: PlayerViewModel())
    }
}
