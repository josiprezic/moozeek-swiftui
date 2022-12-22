//
//  MusicPlayer.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct MusicPlayer: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
        
    // MARK: - Views -
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            subviews
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 30)
                .background(Gradient(colors: [.gray, .black.opacity(0.6)]))
        }
    }
    
    private var subviews: some View {
        VStack {
            Spacer()
            trackLogo
            Spacer()
            songControls
            progressView
            timeView
            playerControls
            volumeControlView
            footerControlView
        }
    }
    
    private var trackLogo: some View {
        HStack {
            AsyncImage(
                url: viewModel.currentSong?.thumbnailUrl,
                content: { image in
                    HStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .aspectRatio(1.0, contentMode: .fit)
                    .background(Color.black)
                    .cornerRadius(Style.Size.playerTrackIconRadius)
                },
                placeholder: { trackLogoPlaceholder }
            )
        }
        .gesture(dragGesture)
    }
    
    private var trackLogoPlaceholder: some View {
        Image(systemName: Style.Image.musicNote)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 100)
            .padding(.vertical, 50)
            .foregroundColor(Color.gray.opacity(0.6))
            .background(
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .fill(Color.black.opacity(0.17))
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, -5)
            .cornerRadius(Style.Size.playerTrackIconRadius)
            .padding(.vertical, 20)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded(onDragGestureEnded)
    }
    
    private func onDragGestureEnded(_ value: DragGesture.Value) {
        if value.translation.height > 60 {
            dismiss()
        }
    }
    
    private var trackTitle: some View {
        Text(viewModel.currentSong?.name ?? "No song")
            .foregroundColor(.white)
            .font(Style.Font.playerTrackTitleFont)
            .bold()
            .lineLimit(Style.Size.playerTrackTitleLineLimit)
    }
    
    private var songMenuButton: some View {
        Menu {
            ForEach(SongDetailMenuItem.allCases) { item in
                Button(
                    action: {
                        guard let currentSong = viewModel.currentSong else { return }
                        viewModel.handleMenuItemSelected(item, for: currentSong)
                    },
                    label: { Label(item.title, systemImage: item.systemImage) }
                )
            }
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                Image(systemName: Style.Image.more)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white.opacity(0.1))
                    )
                
            }
            .frame(width: 25, height: 50)
        }
        .contextMenu {
            Button(action: {}) {
                Text("Share")
                Image(systemName: Style.Image.share)
            }
            // 3.
            Button(action: {}) {
                Image(systemName: Style.Image.favorite)
                Text("Favorite")
            }
        }
    }
    
    private var songControls: some View {
        HStack {
            trackTitle
            Spacer()
            songMenuButton
        }
    }
    
    private var progressView: some View {
        ProgressView(value: viewModel.currentSongPercentage)
            .frame(height: 5)
            .background(Color.gray)
            .foregroundColor(.white)
            .accentColor(.white.opacity(0.6))
            .cornerRadius(2)
        
    }
    
    private var timeView: some View {
        HStack {
            Text(viewModel.currentSongElapsedTime)
            Spacer()
            Text(viewModel.currentSongRemainingTime)
        }
        .foregroundColor(.white.opacity(0.5))
        .font(.system(size: 13))
    }
    
    private var playerControls: some View {
        HStack {
            backwardButton
            playButton
            forwardButton
        }
    }
    
    private var backwardButton: some View {
        Button(action: viewModel.handlePreviousButtonPressed) {
            Image(systemName: Style.Image.backward)
                .foregroundColor(.white)
                .font(.system(size: Style.Size.playerTrackControlSize))
                .padding()
        }
    }
    
    private var playButton: some View {
        Button(action: viewModel.handlePlayButtonPressed) {
            Image(systemName: viewModel.isPlaying ? Style.Image.pause : Style.Image.play)
                .foregroundColor(.white)
                .font(.system(size: 45))
                .frame(width: 55, height: 30)
                .padding()
        }
    }
    
    private var forwardButton: some View {
        Button(action: viewModel.handleNextButtonPressed) {
            Image(systemName: Style.Image.forward)
                .foregroundColor(.white)
                .font(.system(size: Style.Size.playerTrackControlSize))
                .padding()
        }
    }
    
    private var volumeControlView: some View {
        HStack {
            Image(systemName: Style.Image.speakerLow)
            Slider(value: $viewModel.volumeLevelPercentage, in: 0...1, step: 0.01)
                .accentColor(.white.opacity(0.5))
            Image(systemName: Style.Image.speakerHigh)
        }
        .foregroundColor(.white.opacity(0.5))
    }
    
    private var footerControlView: some View {
        HStack {
            Image(systemName: Style.Image.quoteBubble)
            Spacer()
            Image(systemName: Style.Image.airplay)
            Spacer()
            Image(systemName: Style.Image.bulletList)
        }
        .foregroundColor(.white.opacity(0.5))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Previews -

struct MusicPlayer_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayer.resolved
    }
}
