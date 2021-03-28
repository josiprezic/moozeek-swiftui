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
    struct Color { }
    struct Font { }
}


extension Style.Image {
    static let play: String = "play.fill"
    static let forward: String = "forward.fill"
    static let backward = "backward.fill"
}

extension Style.Size {
    
    static let playerTrackIconRadius: CGFloat = 10
    static let playerTrackIconPadding: CGFloat = 40
    static let playerTrackTitleLineLimit = 1
    static let playerTrackControlSize: CGFloat = 30
    static let playerTrackControlsPadding: CGFloat = 30
    
    static let playerBarTrackIcon: CGFloat = 50
    static let playerBarTrackIconRadius: CGFloat = 5
    static let playerBarHeight: CGFloat = 70
}

extension Style.Color {
    static let playerTrackControl = Color.black
    static let playerBackground = Color.gray.opacity(0.4)
    
    static let playerBarBackground = Color.gray
}

extension Style.Font {
    static let playerTrackTitleFont: Font = .system(size: 20)
}

enum Identifiers {
    static let trackIconAnimationName = "logoAnimation"
}