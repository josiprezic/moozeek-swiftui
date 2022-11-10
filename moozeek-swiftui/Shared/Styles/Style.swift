//
//  Constants.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct Style {
    
    struct Image { }
    struct Size { }
    struct Color {
        
    }
    struct Font { }
}


extension Style.Image {
    static let play: String = "play.fill"
    static let stop: String = "stop.fill"
    static let forward: String = "forward.fill"
    static let backward = "backward.fill"
    static let shuffle = "shuffle"
    static let playNext = "text.line.first.and.arrowtriangle.forward"
    static let playLast = "text.line.last.and.arrowtriangle.forward"
    static let more = "ellipsis"
    static let share = "square.and.arrow.up"
    static let favorite = "heart.fill"
    static let musicNote = "music.note"
    static let download = "arrow.down.circle.fill"
    static let trash = "trash"
}

extension Style.Size {
    static let playerTrackIconRadius: CGFloat = 10
    static let playerTrackIconPadding: CGFloat = 40
    static let playerTrackTitleLineLimit = 1
    static let playerTrackControlSize: CGFloat = 30
    static let playerTrackControlsPadding: CGFloat = 30
    static let playerBarTrackIcon: CGFloat = 50
    static let playerBarTrackIconRadius: CGFloat = 5
    static let playerBarHeight: CGFloat = 65
}

extension Style.Color {
//    @Environment(\.colorScheme) private static var colorScheme
//    private static var isDarkMode: Bool { currentSystemScheme == .dark }
//
//    private static var currentSystemScheme: UIUserInterfaceStyle {
//        UITraitCollection.current.userInterfaceStyle
//    }
    
    static let playerTrackControl = Color.black
    static let playerBackground = Color.gray.opacity(0.4)
    static let playerBarBackground = Color.gray.opacity(0.1)
    
    // song list
//    static let songCellBackground = isDarkMode ? Color.black : Color.white
//    static let songCellForeground = isDarkMode ? Color.white : Color.black
}

extension Style.Font {
    static let playerTrackTitleFont: Font = .system(size: 20)
}

enum Identifiers {
    static let trackIconAnimationName = "logoAnimation"
}
