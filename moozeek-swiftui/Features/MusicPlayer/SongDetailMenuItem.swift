//
//  SongDetailMenuItem.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import Foundation

enum SongDetailMenuItem: CaseIterable, Identifiable {
    var id: String { title }
    
    case deleteFromLibrary
    case playNext
    case playLast
    
    var title: String {
        switch self {
        case .deleteFromLibrary:
            return "Delete from Library"
        case .playNext:
            return "Play Next"
        case .playLast:
            return "Play Last"
        }
    }
    
    var systemImage: String {
        switch self {
        case .deleteFromLibrary:
           return Style.Image.trash
        case .playNext:
            return Style.Image.playNext
        case .playLast:
            return Style.Image.playLast
        }
    }
}
