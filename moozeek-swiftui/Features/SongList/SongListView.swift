//
//  SongListView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import SwiftUI

struct SongListView: View {
    
    @ObservedObject var viewModel: SongListViewModel
    @Namespace private var namespace
    
    @State private var showDetails: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if showDetails {
                    Spacer()
                    musicPlayer
                } else {
                    VStack {
                        songListView
                        musicPlayerBar
                    }
                }
            }
            .navigationTitle("Songs")
            .ignoresSafeArea(edges: .bottom)
        }
        .searchable(text: $viewModel.searchText, prompt: "Find in Songs")
    }
    
    private var songListView: some View {
        List {
            Section(header: songListHeaderView) {
                ForEach(viewModel.songs, content: SongCell.init)
            }
            .listRowBackground(Color.black)
        }
        .padding([.bottom], -8)
        .listStyle(GroupedListStyle())
        .foregroundColor(Color.white)
    }
    
    private var songListHeaderView: some View {
        HStack(spacing: 20) {
            HeaderButton(
                title: "Play",
                imageSystemName: "play.fill"
            )
            HeaderButton(
                title: "Shuffle",
                imageSystemName: "shuffle"
            )
        }
        .padding(.horizontal, -5)
        .frame(height: 60)
    }
    
    private var musicPlayer: some View {
        MusicPlayer(namespace: namespace)
            .gesture(dragGesture)
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar(namespace: namespace)
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

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView(viewModel: SongListViewModel())
    }
}
