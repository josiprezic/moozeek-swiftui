//
//  AudioManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import AVFoundation
import Combine

// TODO: JR Refactor
final class AudioManager: NSObject {
    let playerDidFinishPlaying = PassthroughSubject<Void, Never>()
    let currentSongElapsedTime = CurrentValueSubject<Int, Never>(0)
    let currentSongRemainingTime = CurrentValueSubject<Int, Never>(0)
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var currentSongDuration: Int?
    
    private var player: AVAudioPlayer? {
        didSet {
            player?.delegate = self
        }
    }
    
    private(set) var currentSong: Song?
    
    func play(_ song: Song) {
        cancellables.removeAll()
        let url = song.url
        //guard let url = Bundle.main.url(forResource: song.name, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)//, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.prepareToPlay()
            player.volume = 1.0 // TODO: JR
            player.play()
            currentSong = song
            
            let duration = Int(player.duration)
            self.currentSongDuration = duration
            
            // initial values
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
    
    
    
    // TODO: JR
//
//    var audioPlayer: AVAudioPlayer!
//
//    func play2(url: URL) {
//
//
//
//                        do {
//                            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
//                            self.audioPlayer.prepareToPlay()
//                            self.audioPlayer.volume = 1.0
//                            self.audioPlayer.play()
//                        } catch {
//                            self.audioPlayer = nil
//                            print(error.localizedDescription)
//                            print("AVAudioPlayer init failed")
//                        }
////        }
//
//
//
//        return;
//
//        cancellables.removeAll()
//        //guard let url = Bundle.main.url(forResource: song.name, withExtension: "mp3") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//            guard let player = player else { return }
//            player.play()
//            //currentSong = song
//
//            let duration = Int(player.duration)
//            self.currentSongDuration = duration
//
//            // initial values
//            currentSongElapsedTime.send(0)
//            currentSongRemainingTime.send(duration)
//
//            Timer.publish(every: 1, on: .main, in: .default)
//                .autoconnect()
//                .compactMap { [weak self] _ in return self?.player?.currentTime }
//                .map(Int.init)
//                .sink(receiveValue: currentSongElapsedTime.send)
//                .store(in: &cancellables)
//
//            Timer.publish(every: 1, on: .main, in: .default)
//                .autoconnect()
//                .compactMap { [weak self] _ in return self?.player?.currentTime }
//                .map(Int.init)
//                .map { duration - $0 }
//                .sink(receiveValue: currentSongRemainingTime.send)
//                .store(in: &cancellables)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
    
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
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerDidFinishPlaying.send(())
    }
}
