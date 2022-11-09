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
    
    let namespace: Namespace.ID
    
    @State var isPlaying = false
    
    // MARK: - Views -
    
    var body: some View {
        subviews
            .frame(maxWidth: .infinity, maxHeight: Constants.height)
            .background(Constants.background)
    }
    
    private var subviews: some View {
        HStack {
            trackLogo
            trackTitle
            spacer
            playButton
            forwardButton
        }
    }
    
    private var trackLogo: some View {
        Image("gnr_logo") // TODO: JR to be removed
            .resizable()
            .frame(width: Constants.iconSize, height: Constants.iconSize)
            .cornerRadius(Constants.iconCornerRadius)
            .padding()
            .matchedGeometryEffect(id: Constants.animationId, in: namespace)
    }
    
    private var trackTitle: some View {
        Text("Welcome to the Jungle")
            .font(.headline)
            .lineLimit(1)
    }
    
    private var spacer: some View {
        Spacer()
    }
    
    private var playButton: some View {
        Image(systemName: isPlaying ? Constants.playImageName : Constants.stopImageName)
            .padding()
            .onTapGesture {
                isPlaying.toggle()
            }
    }
    
    private var forwardButton: some View {
        Image(systemName: Constants.forwardImageName)
            .padding()
    }
}

// MARK: - Previews -

struct MusicPlayerBar_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        MusicPlayerBar(namespace: namespace)
    }
}
