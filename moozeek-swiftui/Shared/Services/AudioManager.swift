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
    
    private var player: AVAudioPlayer? {
        didSet {
            player?.delegate = self
        }
    }
    
    private(set) var currentSong: Song?
    
    func play(_ song: Song) {
        cancellables.removeAll()
        guard let url = Bundle.main.url(forResource: song.name, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
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
            print(error.localizedDescription)
        }
    }
    
    // TODO: JR MOVE
    func convertToAudio(url: URL, completion: @escaping (_ url: URL) -> Void) {
        let composition = AVMutableComposition()
        do {
            let sourceUrl = url//Bundle.main.url(forResource: "Movie", withExtension: "mov")!
            
            let asset = AVURLAsset(url: sourceUrl)
            guard let audioAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else { return  }
            guard let audioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid) else { return  }
            try audioCompositionTrack.insertTimeRange(audioAssetTrack.timeRange, of: audioAssetTrack, at: CMTime.zero)
        } catch {
            print(error)
        }
        
        // Get url for output
        let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "out.m4a")
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            try? FileManager.default.removeItem(atPath: outputUrl.path)
        }
        
        // Create an export session
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
        exportSession.outputFileType = AVFileType.m4a
        exportSession.outputURL = outputUrl
        
        // Export file
        exportSession.exportAsynchronously {
            guard case exportSession.status = AVAssetExportSession.Status.completed else { return }
            
            DispatchQueue.main.async {
                // Present a UIActivityViewController to share audio file
                guard let outputURL = exportSession.outputURL else { return }
                
                //                return outputURL
                
                //                let activityViewController = UIActivityViewController(activityItems: [outputURL], applicationActivities: [])
                //                self.present(activityViewController, animated: true, completion: nil)
                print("Jupiiiii")
                
                
                
                func getDocumentsDirectory() -> URL {
                       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                       let documentsDirectory = paths[0]
                       return documentsDirectory
                }
                
                
                
                
                
                var newURL = getDocumentsDirectory()
                
//                let newName = outputURL.lastPathComponent.split(separator: ".").first! + ".mp3"
//                print("NEW NAME: \(newName)")
                
                newURL.appendPathComponent(outputURL.lastPathComponent)
//                newURL.appendPathComponent(outputURL.lastPathComponent)
                
                do {
                    if FileManager.default.fileExists(atPath: newURL.path) {
                        try FileManager.default.removeItem(atPath: newURL.path)
                    }
                    try FileManager.default.moveItem(atPath: outputURL.path, toPath: newURL.path)
                    print("The new URL: \(newURL)")
                    
                    completion(newURL)
                } catch {
                    print(error.localizedDescription)
                
            
                }
            }
        }
    }
    
    // TODO: JR
    
    var audioPlayer: AVAudioPlayer!
    
    func play2(url: URL) {
        
       

                        do {
                            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                            self.audioPlayer.prepareToPlay()
                            self.audioPlayer.volume = 1.0
                            self.audioPlayer.play()
                        } catch {
                            self.audioPlayer = nil
                            print(error.localizedDescription)
                            print("AVAudioPlayer init failed")
                        }
//        }
        
        
        
        return;
        
        
        
        
//        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        print("File Location: ",url.path)
//
//        if(FileManager.default.fileExists(atPath: url.path)) {
//           do {
//               audioPlayer = try AVAudioPlayer(contentsOf: url)
//               guard let player = audioPlayer else { return }
//
//               player.prepareToPlay()
//           } catch let error {
//               print(error.localizedDescription)
//           }
//
//        } else {
//            print("file not found")
//        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        cancellables.removeAll()
        //guard let url = Bundle.main.url(forResource: song.name, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
            //currentSong = song
            
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
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerDidFinishPlaying.send(())
    }
}
