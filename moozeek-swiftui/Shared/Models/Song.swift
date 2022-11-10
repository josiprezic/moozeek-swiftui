//
//  Song.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import Foundation

struct Song: Identifiable {
    let id = UUID()
    let name: String
    
    static let example = Song(name: "Test song name")
}
