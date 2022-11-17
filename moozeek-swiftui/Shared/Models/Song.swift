//
//  Song.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import Foundation

struct Song: Identifiable, Equatable {
    let id = UUID()
    var name: String {
        url.lastPathComponent
    }
//    var thumbnailUrl: URL {
//
//    }
    var url: URL
    
    static let example = Song(url: URL(string: "www.google.com")!)
}
