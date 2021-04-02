//
//  PlayerViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 4/2/21.
//

import Foundation

final class PlayerViewModel: ObservableObject {
    
    @Published var testTracks: [Track] = {
        Array(repeating: Track(title: "Test title"), count: 30)
    }()
}
