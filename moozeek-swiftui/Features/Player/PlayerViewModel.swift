//
//  PlayerViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import Foundation
import Combine


final class PlayerViewModel: ViewModel, ObservableObject {
    
    // MARK: - Properties
    
    @Published var songs: [Song]
    @Published var searchText: String
    
    @Published var isPlaying = false
    @Published var isShuffle = false
    
    @Published var currentSong: Song?
    @Published var currentSongPercentage: Float = 0.4
    @Published var currentSongElapsedTime: String = ""
    @Published var currentSongRemainingTime: String = ""
    @Published var volumeLevelPercentage: Float = 0.8
    
    private let allSongs: [Song]
    private let audioManager: AudioManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    
    init(audioManager: AudioManager) {
        self.audioManager = audioManager
        
        allSongs = [
            Song(name: "Intro music"),
            Song(name: "Billy Joel- Vienna"),
            Song(name: "Guns N’ Roses - Sweet Child O’ Mine"),
            Song(name: "It's My Life - Bon Jovi")
        ]
        songs = allSongs
        currentSong = allSongs.first
        searchText = ""
        super.init()
    }
    
    // MARK: - Setup
    
    override func setupObservables() {
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
        
        audioManager.currentSongElapsedTime
            .map(\.timeString)
            .assign(to: &$currentSongElapsedTime)
        
        audioManager.currentSongRemainingTime
            .map(\.timeString)
            .map { "-" + $0 }
            .assign(to: &$currentSongRemainingTime)
        
        audioManager.currentSongElapsedTime
            .map(Float.init)
            .map { [weak self] in $0 / Float(self?.audioManager.currentSongDuration ?? 1) }
            .assign(to: &$currentSongPercentage)
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
    
    private func playShuffleSong() {
        let songCandidates = self.songs.filter { $0 != currentSong }
        guard let randomSong = songCandidates.randomElement() else { return }
        playSong(song: randomSong)
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
        if isShuffle {
            playShuffleSong()
        } else {
            playNextSong()
        }
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
        if isShuffle {
            playShuffleSong()
        } else {
            playNextSong()
        }
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
        isShuffle = false
        playFirstAvailableSong()
    }
    
    func handleHeaderShufflePlayButtonTapped() {
        isShuffle = true
        playShuffleSong()
    }
}
