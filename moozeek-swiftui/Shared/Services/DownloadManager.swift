//
//  DownloadManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import XCDYouTubeKit
import Combine

enum AudioError: Error {
    case videoNotAvailable(error: Error?)
    case unableToConvertVideo(error: Error?)
}

// TODO: JR To be refactored
final class DownloadManager {
    func downloadYouTubeVideo(videoID: String) -> AnyPublisher<Bool, AudioError> {
        let publisher = PassthroughSubject<Bool, AudioError>()
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoID) { (video, error) in
            if error != nil || video == nil {
                publisher.send(completion: .failure(.videoNotAvailable(error: error)))
                return
            }
            
            guard let video else { return }
            
            LibraryManager().addSongToLibrary(
                songTitle: video.title,
                songUrl: video.streamURL!,
                songExtension: "mp4",
                thumbnailUrl: video.thumbnailURLs![video.thumbnailURLs!.count/2],
                songID: videoID
            ) {
                publisher.send(true)
            }
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func convertToAudio(url: URL) -> AnyPublisher<URL, AudioError> {
        let publisher = PassthroughSubject<URL, AudioError>()
        
        let composition = AVMutableComposition()
        do {
            let asset = AVURLAsset(url: url)
            
            guard let audioAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else {
//                publisher.send(completion: .failure(.unableToConvertVideo(error: nil)))
//                return publisher.eraseToAnyPublisher()
                throw AudioError.unableToConvertVideo(error: nil)
            }
            
            guard let audioCompositionTrack = composition.addMutableTrack(
                withMediaType: AVMediaType.audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
            ) else {
//                publisher.send(completion: .failure(.unableToConvertVideo(error: nil)))
//                return publisher.eraseToAnyPublisher()
                throw AudioError.unableToConvertVideo(error: nil)
            }
            
            try audioCompositionTrack.insertTimeRange(
                audioAssetTrack.timeRange,
                of: audioAssetTrack, at: CMTime.zero
            )
        } catch {
            publisher.send(completion: .failure(.unableToConvertVideo(error: error)))
            return publisher.eraseToAnyPublisher()
        }
        
        let outputFileName = url.lastPathComponent.split(separator: ".")[0] + ".m4a"
        let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + outputFileName)
        
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            try? FileManager.default.removeItem(atPath: outputUrl.path)
        }
        
        // Create an export session
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
        exportSession.outputFileType = AVFileType.m4a
        exportSession.outputURL = outputUrl
        
        // Export file
        exportSession.exportAsynchronously {
            guard case exportSession.status = AVAssetExportSession.Status.completed else {
                publisher.send(completion: .failure(.unableToConvertVideo(error: nil)))
                return
            }
            
            DispatchQueue.main.async {
                guard let outputURL = exportSession.outputURL else {
                    publisher.send(completion: .failure(.unableToConvertVideo(error: nil)))
                    return
                }
                var newURL = URL(string: LocalFilesManager.documentDirectory())!
                newURL.appendPathComponent(outputURL.lastPathComponent)
                
                do {
                    if FileManager.default.fileExists(atPath: newURL.path) {
                        try FileManager.default.removeItem(atPath: newURL.path)
                    }
                    try FileManager.default.moveItem(atPath: outputURL.path, toPath: newURL.path)
                    publisher.send(newURL)
                } catch {
                    publisher.send(completion: .failure(.unableToConvertVideo(error: error)))
                }
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
