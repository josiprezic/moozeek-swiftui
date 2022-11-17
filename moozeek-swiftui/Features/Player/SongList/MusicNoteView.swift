//
//  MusicNoteView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import SwiftUI

struct MusicNoteView: View {
    var body: some View {
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
    }
}

struct MusicNoteView_Previews: PreviewProvider {
    static var previews: some View {
        MusicNoteView()
    }
}

// TODO: JR Refactor and Move
struct ThumbnailView: View {
    let song: Song?
    
    var body: some View {
        AsyncImage(
            url: song?.thumbnailUrl,
            content: {
                $0
                    .resizable()
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
            },
            placeholder: MusicNoteView.init
        )
        .frame(width: 50, height: 50)
        .scaledToFill()
        .clipped()
        .cornerRadius(5)
        .padding(.trailing, 5)
    }
}
