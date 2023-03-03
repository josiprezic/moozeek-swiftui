//
//  PlayNextListView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 14/02/2023.
//

import SwiftUI

struct PlayNextListView: View {
    var body: some View {
        ScrollView {
            ForEach(1..<50) { _ in
                PlayNextSongCell()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.gray)
        .aspectRatio(1.0, contentMode: .fit)
    }
}


struct PlayNextSongCell: View {
    var body: some View {
        Button(action: { }) {
            HStack {
                thumbnailView
                songTitle
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
    
    var thumbnailView: some View {
        Rectangle()
            .frame(height: 40)
            .aspectRatio(1, contentMode: .fit)
    }
    
    var songTitle: some View {
        Text("Song name")
            .lineLimit(1)
    }
}
