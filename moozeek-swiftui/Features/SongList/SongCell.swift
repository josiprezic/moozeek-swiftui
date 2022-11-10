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
        Image(systemName: Style.Image.musicNote)
            .buttonStyle(PlainButtonStyle())
            .frame(width: 50, height: 50)
            .foregroundColor(Color.gray.opacity(0.6))
            .background(
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .fill(Color.gray.opacity(0.17))
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.trailing, 12)
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
                    .padding()
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
}

struct SongCell_Previews: PreviewProvider {
    static var previews: some View {
        SongCell(song: Song.example)
    }
}
