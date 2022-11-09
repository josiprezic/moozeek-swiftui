//
//  SongListViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import Foundation
import Combine


final class SongListViewModel: ObservableObject {
    
    @Published var songs: [Song]
    @Published var searchText: String
    
    private var allSongs: [Song]
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        allSongs = (1...30).map { Song.init(name: "My super song \($0)") }
        songs = allSongs
        searchText = ""
        setupPublishers()
    }
    
    private func setupPublishers() {
        $searchText
            .map { return $0.lowercased() }
            .sink(receiveValue: handleSearchTextChanged)
            .store(in: &cancellables)
    }
    
    private func handleSearchTextChanged(_ searchText: String) {
        if searchText.isEmpty {
            songs = allSongs
            return
        }
        songs = allSongs.filter {
            $0.name
                .lowercased()
                .contains(searchText)
        }
    }
}
