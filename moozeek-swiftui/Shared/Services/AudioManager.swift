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
    
    var player: AVAudioPlayer? {
        didSet {
            player?.delegate = self
        }
    }
    
    private(set) var currentSong: Song?
    
    func play(_ song: Song) {
        guard let url = Bundle.main.url(forResource: song.name, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
            currentSong = song
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func stop() {
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
