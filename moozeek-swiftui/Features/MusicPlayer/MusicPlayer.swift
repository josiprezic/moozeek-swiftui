//
//  MusicPlayer.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct MusicPlayer: View {
    
    // MARK: - Constants -
    
    enum Constants {
        static let backwardImageName = Style.Image.backward
        static let playImageName = Style.Image.play
        static let forwardImageName = Style.Image.forward
        static let imageCornerRadius = Style.Size.playerTrackIconRadius
        static let animationId = Identifiers.trackIconAnimationName
        static let trackTitleFont = Style.Font.playerTrackTitleFont
        static let trackTitleLineLimit = Style.Size.playerTrackTitleLineLimit
        static let trackControlColor = Color.white
        static let trackControlSize = Style.Size.playerTrackControlSize
        static let controlsViewPadding = Style.Size.playerTrackControlsPadding
    }
    
    // MARK: - Properties
    @StateObject var viewModel: SongListViewModel
    
    let namespace: Namespace.ID
    
    // MARK: - Views -
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            subviews
                .background(Gradient(colors: [.gray, .black.opacity(0.6)]))
        }
    }
    
    private var subviews: some View {
        VStack {
            Spacer()
            trackLogo
            Spacer()
            HStack {
                trackTitle
                Spacer()
                songMenuButton
            }
            progressView
            timeView
            playerControls
            volumeControlView
            footerControlView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 30)
    }
    
    private var trackLogo: some View {
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
            .cornerRadius(Constants.imageCornerRadius)
            .padding(.vertical, 20)
    }
    
    private var trackTitle: some View {
        Text(viewModel.currentSong?.name ?? "No song")
            .foregroundColor(.white)
            .font(Constants.trackTitleFont)
            .bold()
            .lineLimit(Constants.trackTitleLineLimit)
    }
    
    private var songMenuButton: some View {
        Menu {
            Button(action: {
                
            }) {
                Label("Delete from Library", systemImage: Style.Image.trash)
                    .tint(Color.red)
                    .accentColor(.red)
                    .background(Color.red)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            
            Button(action: {
                
            }) {
                Label("Play Next", systemImage: Style.Image.playNext)
            }
            Button(action: {
                
            }) {
                Label("Play Last", systemImage: Style.Image.playLast)
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
            Image(systemName: Constants.backwardImageName)
                .foregroundColor(Constants.trackControlColor)
                .font(.system(size: Constants.trackControlSize))
                .padding()
        }
    }
    
    private var playButton: some View {
        Button(action: viewModel.handlePlayButtonPressed) {
            Image(systemName: viewModel.isPlaying ? Style.Image.stop : Style.Image.play)
                .foregroundColor(Constants.trackControlColor)
                .font(.system(size: Constants.trackControlSize))
                .frame(width: 30, height: 30)
                .padding()
        }
    }
    
    private var forwardButton: some View {
        Button(action: viewModel.handleNextButtonPressed) {
            Image(systemName: Constants.forwardImageName)
                .foregroundColor(Constants.trackControlColor)
                .font(.system(size: Constants.trackControlSize))
                .padding()
        }
    }
    
    private var volumeControlView: some View {
        HStack {
            Image(systemName: "volume.fill")
            
            Slider(value: $viewModel.volumeLevelPercentage)
                .accentColor(.white.opacity(0.5))
            Image(systemName: "speaker.wave.3.fill")
            
        }
        .foregroundColor(.white.opacity(0.5))
    }
    
    private var footerControlView: some View {
        HStack {
            Image(systemName: "quote.bubble")
            Spacer()
            Image(systemName: "airplayaudio")
            Spacer()
            Image(systemName: "list.bullet")
        }
        .foregroundColor(.white.opacity(0.5))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Previews -

struct MusicPlayer_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        MusicPlayer(viewModel: SongListViewModel(), namespace: namespace)
    }
}
