//
//  SongListViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import Foundation


final class SongListViewModel: ObservableObject {
    
    var songs: [Song] {
        Array<Song>(repeating: Song(name: "My super song"), count: 30)
    }
}
