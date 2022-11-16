//
//  MusicPlayerBar.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct MusicPlayerBar: View {
    
    // MARK: - Properties -
    
    @StateObject var viewModel: PlayerViewModel
    
    // MARK: - Views -
    
    var body: some View {
        VStack {
            separator
            HStack {
                trackLogo
                trackTitle
                Spacer()
                playButton
                forwardButton
            }
            .padding(.vertical, -16)
            separator
        }
        .frame(maxWidth: .infinity, maxHeight: Style.Size.playerBarHeight)
        .background(Style.Color.playerBarBackground)
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
        Image(systemName: Style.Image.forward)
            .onTapGesture(perform: viewModel.handleNextButtonPressed)
            .frame(width: 30)
            .padding(.trailing, 15)
    }
    
    private var separator: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.3))
            .frame(maxWidth: .infinity)
            .frame(height: 0.5)
    }
}

// MARK: - Previews -

struct MusicPlayerBar_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerBar(viewModel: PlayerViewModel())
    }
}
