//
//  SongListView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import SwiftUI

struct SongListView: View {
    
    @ObservedObject var viewModel: PlayerViewModel
    @Namespace private var namespace
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showDetails: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                songListView
                musicPlayerBar
            }
            .navigationTitle("Songs")
        }
        .searchable(text: $viewModel.searchText, prompt: "Find in Songs")
        .fullScreenCover(isPresented: $showDetails) { musicPlayer }
    }
    
    private var songListView: some View {
        List {
            Section(header: songListHeaderView) {
                ForEach(viewModel.songs) { song in
                    SongCell(song: song)
                        .onTapGesture { viewModel.handleSongSelected(song) }
                        .onLongPressGesture {
                            print("Song item long press gesture")
                        }
                }
            }
            .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
        }
        .padding([.bottom], -8)
        .listStyle(GroupedListStyle())
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        
    }
    
    private var songListHeaderView: some View {
        HStack(spacing: 20) {
            HeaderButton(
                title: "Play",
                imageSystemName: Style.Image.play,
                action: viewModel.handleHeaderPlayButtonTapped
            )
            HeaderButton(
                title: "Shuffle",
                imageSystemName: Style.Image.shuffle,
                action: viewModel.handleHeaderShufflePlayButtonTapped
            )
        }
        .padding(.horizontal, -5)
        .frame(height: 60)
    }
    
    private var musicPlayer: some View {
        MusicPlayer(viewModel: viewModel)
            .gesture(dragGesture)
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar(viewModel: viewModel)
        .onTapGesture(perform: onMusicPlayerBarTapGesture)
        .gesture(dragGesture)
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
        if value.translation.height < 20 {
            showDetails = true
        } else if value.translation.height > 50 {
            showDetails = false
        }
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView(viewModel: PlayerViewModel())
    }
}
