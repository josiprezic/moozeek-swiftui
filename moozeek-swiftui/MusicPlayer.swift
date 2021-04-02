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
        static let imagePadding = Style.Size.playerTrackIconPadding
        static let animationId = Identifiers.trackIconAnimationName
        static let trackTitleFont = Style.Font.playerTrackTitleFont
        static let trackTitleLineLimit = Style.Size.playerTrackTitleLineLimit
        static let trackControlColor = Style.Color.playerTrackControl
        static let trackControlSize = Style.Size.playerTrackControlSize
        static let controlsViewPadding = Style.Size.playerTrackControlsPadding
        static let background = Style.Color.playerBackground
    }
    
    // MARK: - Properties
    
    let namespace: Namespace.ID
    
    // MARK: - Views -
    var body: some View {
        subviews
            .background(Constants.background)
            .ignoresSafeArea(edges: .top)
    }
    
    private var subviews: some View {
        VStack {
            trackLogo
            trackTitle
            spacer
            playerControls
        }
    }
    
    private var trackLogo: some View {
        Image("gnr_logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(Constants.imageCornerRadius)
            .padding(Constants.imagePadding)
            .matchedGeometryEffect(id: Constants.animationId, in: namespace)
    }
    
    private var trackTitle: some View {
        Text("Guns N'Roses - Welcome to the Jungle")
            .font(Constants.trackTitleFont)
            .bold()
            .lineLimit(Constants.trackTitleLineLimit)
            .padding()
    }
    
    private var spacer: some View {
        Spacer()
    }
    
    private var playerControls: some View {
        HStack {
            backwardButton
            playButton
            forwardButton
        }
        .padding(Constants.controlsViewPadding)
    }
    
    private var backwardButton: some View {
        Image(systemName: Constants.backwardImageName)
            .foregroundColor(Constants.trackControlColor)
            .font(.system(size: Constants.trackControlSize))
            .padding()
    }
    
    private var playButton: some View {
        Image(systemName: Constants.playImageName)
            .foregroundColor(Constants.trackControlColor)
            .font(.system(size: Constants.trackControlSize))
            .padding()
    }
    
    private var forwardButton: some View {
        Image(systemName: Constants.forwardImageName)
            .foregroundColor(Constants.trackControlColor)
            .font(.system(size: Constants.trackControlSize))
            .padding()
    }
}

// MARK: - Previews -

struct MusicPlayer_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        MusicPlayer(namespace: namespace)
    }
}
