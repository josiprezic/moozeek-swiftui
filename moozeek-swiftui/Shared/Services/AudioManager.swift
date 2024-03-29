//
//  AudioManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import AVFoundation
import Combine

final class AudioManager: NSObject {
    let playerDidFinishPlaying = PassthroughSubject<Void, Never>()
    let currentSongElapsedTime = CurrentValueSubject<Int, Never>(0)
    let currentSongRemainingTime = CurrentValueSubject<Int, Never>(0)
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var currentSongDuration: Int?
    
    private let audioSession = AVAudioSession.sharedInstance()
    private var player: AVAudioPlayer? {
        didSet {
            player?.delegate = self
        }
    }
    
    private(set) var currentSong: Song?
    
    func play(_ song: Song) {
        cancellables.removeAll()
        let url = song.url
        
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            currentSong = song
            let duration = Int(player.duration)
            self.currentSongDuration = duration
            
            // initial publisher values
            currentSongElapsedTime.send(0)
            currentSongRemainingTime.send(duration)
            
            Timer.publish(every: 1, on: .main, in: .default)
                .autoconnect()
                .compactMap { [weak self] _ in return self?.player?.currentTime }
                .map(Int.init)
                .sink(receiveValue: currentSongElapsedTime.send)
                .store(in: &cancellables)
            
            Timer.publish(every: 1, on: .main, in: .default)
                .autoconnect()
                .compactMap { [weak self] _ in return self?.player?.currentTime }
                .map(Int.init)
                .map { duration - $0 }
                .sink(receiveValue: currentSongRemainingTime.send)
                .store(in: &cancellables)
        } catch let error {
            player = nil
            print(error.localizedDescription)
        }
    }
    
    func stop() {
        cancellables.removeAll()
        player?.stop()
    }
    
    func pause() {
        player?.pause()
    }
    
    func resume() {
        player?.play()
    }
    
    func resumeOrPlay(_ song: Song) {
        if currentSong == nil {
            play(song)
        } else if currentSong != song {
            play(song)
        } else {
            resume()
        }
    }
    
    func setVolumePercentage(_ value: Float) {
        player?.setVolume(value / 100.0, fadeDuration: 1)
    }
    
    func setCurrentSongTime(inPercentage: Double) {
        let songDuration = player?.duration ?? 0.0
        let selectedTime = songDuration * inPercentage
        player?.currentTime = selectedTime
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerDidFinishPlaying.send(())
    }
}
