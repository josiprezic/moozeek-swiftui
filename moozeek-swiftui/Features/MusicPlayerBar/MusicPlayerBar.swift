//
//  MusicPlayerBar.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct MusicPlayerBar: View {
    
    // MARK: - Constants -
    
    enum Constants {
        static let iconSize = Style.Size.playerBarTrackIcon
        static let iconCornerRadius = Style.Size.playerBarTrackIconRadius
        static let animationId = Identifiers.trackIconAnimationName
        static let playImageName = Style.Image.play
        static let stopImageName = Style.Image.stop
        static let forwardImageName = Style.Image.forward
        static let height = Style.Size.playerBarHeight
        static let background = Style.Color.playerBarBackground
    }
    
    // MARK: - Properties -
    
    @StateObject var viewModel: SongListViewModel
    
    // MARK: - Views -
    
    var body: some View {
        VStack {
            HStack {
                trackLogo
                trackTitle
                Spacer()
                playButton
                forwardButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: Constants.height)
        .background(Constants.background)
    }
    
    private var trackLogo: some View {
        MusicNoteView()
            .padding()
        
//        Image("gnr_logo")
//            .resizable()
//            .frame(width: Constants.iconSize, height: Constants.iconSize)
//            .cornerRadius(Constants.iconCornerRadius)
//            .padding()
//            .matchedGeometryEffect(id: Constants.animationId, in: namespace)
    }
    
    private var trackTitle: some View {
        Text(viewModel.currentSong?.name ?? "No song")
            .font(.headline)
            .lineLimit(1)
    }
    
    private var playButton: some View {
        Image(systemName: viewModel.isPlaying ? Style.Image.pause : Style.Image.play)
            .onTapGesture(perform: viewModel.handlePlayButtonPressed)
            .frame(width: 30)
            .padding(.trailing, 5)
    }
    
    private var forwardButton: some View {
        Image(systemName: Constants.forwardImageName)
            .onTapGesture(perform: viewModel.handleNextButtonPressed)
            .frame(width: 30)
            .padding(.trailing, 15)
    }
}

// MARK: - Previews -

struct MusicPlayerBar_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerBar(viewModel: SongListViewModel())
    }
}
