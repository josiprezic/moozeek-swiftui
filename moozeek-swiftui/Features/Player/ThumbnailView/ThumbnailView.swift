//
//  ThumbnailView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 19/11/2022.
//

import SwiftUI

struct ThumbnailView: View {
    let song: Song?

    var body: some View {
        AsyncImage(
            url: song?.thumbnailUrl,
            content: {
                $0
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipped()
                
            },
            placeholder: MusicNoteView.init
        )
        .frame(width: 50, height: 50)
        .cornerRadius(5)
        .padding(.trailing, 5)
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView(song: nil)
    }
}
