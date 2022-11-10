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
            musicNoteIcon
            Text(song.name)
            Spacer()
            downloadButton
            menuButton
        }
        .padding(-5)
        .buttonStyle(PlainButtonStyle())
    }
    
    var musicNoteIcon: some View {
        MusicNoteView()
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
        Menu {
            ForEach(SongDetailMenuItem.allCases) { item in
                Button(action: {}, label: {
                    Label(item.title, systemImage: item.systemImage)
                })
            }
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                Image(systemName: Style.Image.more)
                    .padding()
            }
            .frame(width: 25, height: 50)
        }
        .contextMenu {
            ForEach(SongDetailMenuItem.allCases) { item in
                Button(action: {}, label: {
                    Label(item.title, systemImage: item.systemImage)
                })
            }
        }
    }
}

struct SongCell_Previews: PreviewProvider {
    static var previews: some View {
        SongCell(song: Song.example)
    }
}

