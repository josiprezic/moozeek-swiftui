//
//  Song.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import Foundation

struct Song: Identifiable, Equatable {
    let id = UUID()
    let url: URL
    
    var name: String {
        var songName = url.lastPathComponent
        songName.removeLast(4)
        return songName
    }
    
    var thumbnailUrl: URL? {
        var urlCopy = url.absoluteString
        urlCopy.removeLast(3)
        return URL(string: urlCopy + "jpg")
    }
    
    static let example = Song(url: URL(string: "www.google.com")!)
}
