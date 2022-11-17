//
//  SongCell.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import SwiftUI

struct SongCell: View {
    let song: Song
    
    var body: some View {
        HStack {
            thumbnailView
            songTitle
            Spacer()
            downloadButton
            menuButton
        }
        .padding(-5)
        .buttonStyle(PlainButtonStyle())
    }
    
    var thumbnailView: some View {
        ThumbnailView(song: song)
    }
    
    var songTitle: some View {
        Text(song.name)
            .lineLimit(1)
    }
    
    var downloadButton: some View {
        Button(action: {},
               label: {
            Image(systemName: Style.Image.download)
                .resizable()
                .frame(width: 12, height: 12)
                .opacity(0.3)
        })
    }
    
    var menuButton: some View {
        Menu { menuContent } label: { moreButton }
            .contextMenu { menuContent }
    }
    
    var menuContent: some View {
        ForEach(SongDetailMenuItem.allCases) { item in
            Button(action: {}, label: {
                Label(item.title, systemImage: item.systemImage)
            })
        }
    }
    
    var moreButton: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
            Image(systemName: Style.Image.more)
                .padding()
        }
        .frame(width: 25, height: 50)
    }
}

struct SongCell_Previews: PreviewProvider {
    static var previews: some View {
        SongCell(song: Song.example)
    }
}

