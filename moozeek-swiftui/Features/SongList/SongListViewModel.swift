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
    @Published var isPlaying = false
    @Published var isShuffle = false
    @Published var currentSong: Song?
    
    private var allSongs: [Song]
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        allSongs = (1...30).map { Song.init(name: "My super song \($0)") }
        allSongs.insert(contentsOf: [
            Song(name: "Bon Jovi - It's my life"),
            Song(name: "Alan Walker - The Spectre"),
            Song(name: "ATC - All Arround the World")
        ], at: 0)
        
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
    
    // MARK: - Methods
    
    private func playFirstAvailableSong() {
        guard let firstSong = songs.first else { return }
        playSong(song: firstSong)
    }
    
    private func playSong(song: Song) {
        currentSong = song
        isPlaying = true
    }
    
    // MARK: - Handlers
    
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
    
    func handleSongSelected(_ song: Song) {
        currentSong = song
        isPlaying = true
    }
    
    func handlePlayButtonPressed() {
        isPlaying.toggle()
    }
    
    func handleNextButtonPressed() {
        guard let currentSongIndex = songs.firstIndex(where: { $0.id == currentSong?.id }) else {
            playFirstAvailableSong()
            return
        }
        let nextSongIndex = (currentSongIndex + 1) % songs.count
        let nextSong = songs[nextSongIndex]
        playSong(song: nextSong)
    }
    
    func handleHeaderPlayButtonTapped() {
        playFirstAvailableSong()
    }
    
    func handleHeaderShufflePlayButtonTapped() {
        guard let randomSong = songs.randomElement() else { return }
        isShuffle = true
        playSong(song: randomSong)
    }
}
