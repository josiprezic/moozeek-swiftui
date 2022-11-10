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
    }
    
    var musicNoteIcon: some View {
        Image(systemName: "music.note")
            .buttonStyle(PlainButtonStyle())
            .frame(width: 50, height: 50)
            .foregroundColor(Color.white.opacity(0.4))
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
                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            )
            .padding(.trailing, 12)
    }
    
    var downloadButton: some View {
        Button(action: {},
               label: {
            Image(systemName: "arrow.down.circle.fill")
                .resizable()
                .frame(width: 12, height: 12)
                .opacity(0.3)
        })
    }
    
    var menuButton: some View {
        Button(
            action: {},
            label: {
                Image(systemName: "ellipsis")
            }
        )
    }
}

struct SongCell_Previews: PreviewProvider {
    static var previews: some View {
        SongCell(song: Song.example)
    }
}
