//
//  SongListViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import Foundation
import Combine


final class SongListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var songs: [Song]
    @Published var searchText: String
    
    @Published var isPlaying = false
    @Published var isShuffle = false

    @Published var currentSong: Song?
    @Published var currentSongPercentage: Float = 0.4
    @Published var currentSongElapsedTime: String = "2:45"
    @Published var currentSongRemainingTime: String = "-3:11"
    @Published var volumeLevelPercentage: Float = 0.8
    
    private let allSongs: [Song]
    private let audioManager: AudioManager = AudioManager()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    
    init() {
        allSongs = [
            Song(name: "Intro music"),
            Song(name: "Billy Joel- Vienna"),
            Song(name: "Guns N’ Roses - Sweet Child O’ Mine"),
            Song(name: "It's My Life - Bon Jovi")
        ]
        songs = allSongs
        currentSong = allSongs.first
        searchText = ""
        setupPublishers()
    }
    
    // MARK: - Setup
    
    private func setupPublishers() {
        $searchText
            .map { return $0.lowercased() }
            .sink(receiveValue: handleSearchTextChanged)
            .store(in: &cancellables)
        
        $isPlaying
            .sink(receiveValue: handleIsPlayingValueChanged)
            .store(in: &cancellables)
        
        audioManager.playerDidFinishPlaying
            .sink(receiveValue: handleSongDidFinishedPlaying)
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
    
    private func playNextSong() {
        guard let currentSongIndex = songs.firstIndex(where: { $0.id == currentSong?.id }) else {
            playFirstAvailableSong()
            return
        }
        let nextSongIndex = (currentSongIndex + 1) % songs.count
        let nextSong = songs[nextSongIndex]
        playSong(song: nextSong)
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
    
    private func handleIsPlayingValueChanged(_ isPlaying: Bool) {
        if isPlaying {
            guard let currentSong else { return }
            audioManager.resumeOrPlay(currentSong)
        } else {
            audioManager.pause()
        }
    }
    
    private func handleSongDidFinishedPlaying() {
        playNextSong()
    }
    
    func handleSongSelected(_ song: Song) {
        currentSong = song
        isPlaying = true
    }
    
    func handlePlayButtonPressed() {
        if currentSong == nil {
            playFirstAvailableSong()
        } else {
            isPlaying.toggle()
        }
    }
    
    func handleNextButtonPressed() {
        playNextSong()
    }
    
    func handlePreviousButtonPressed() {
        guard let currentSongIndex = songs.firstIndex(where: { $0.id == currentSong?.id }) else {
            playFirstAvailableSong()
            return
        }
        let previousSongIndex = (currentSongIndex - 1 + songs.count) % songs.count
        let previousSong = songs[previousSongIndex]
        playSong(song: previousSong)
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
