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
    
    private let libraryManager: LibraryManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(libraryManager: LibraryManager) {
        self.libraryManager = libraryManager
    }
    
    func downloadYouTubeSong(from urlString: String) {
        let videoId = getVideoId(from: urlString)
        downloadYouTubeVideo(videoID: videoId)
            .sink(receiveCompletion: { completion in
                // TODO: JR handle
            }, receiveValue: { [weak self] finished in
                // handle completion
                self?.convertVideosToSongs()
            })
            .store(in: &cancellables)
    }
    
    private func getVideoId(from urlString: String) -> String {
        // TODO: JR add checks
        String(urlString.suffix(11))
    }
    
    private func downloadYouTubeVideo(videoID: String) -> AnyPublisher<Bool, AudioError> {
        let publisher = PassthroughSubject<Bool, AudioError>()
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoID) { [weak self] (video, error) in
            if error != nil || video == nil {
                publisher.send(completion: .failure(.videoNotAvailable(error: error)))
                return
            }
            
            guard let video else { return }
            
            self?.libraryManager.addSongToLibrary(
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
    
    
    func convertVideosToSongs() {
        do {
            let path = LocalFilesManager.documentDirectoryUrl.absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
            
            let filesToConvert = directoryContents.filter {
                $0.lastPathComponent.split(separator: ".").last! == "mp4"
            }
            
            convertToAudio(url: filesToConvert.first!)
                .sink(receiveCompletion: { error in
                    // handle error
                    print(error)
                }, receiveValue: { url in
                    // handle url, but probably not needed
                })
                .store(in: &self.cancellables)
        } catch {
            // TODO: JR handle
        }
    }
    
    
    func convertToAudio(url: URL) -> AnyPublisher<URL, AudioError> {
        let publisher = PassthroughSubject<URL, AudioError>()
        
        let composition = AVMutableComposition()
        do {
            let asset = AVURLAsset(url: url)
            
            guard let audioAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else {
                throw AudioError.unableToConvertVideo(error: nil)
            }
            
            guard let audioCompositionTrack = composition.addMutableTrack(
                withMediaType: AVMediaType.audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
            ) else {
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
        
        let outputFileName = url.lastPathComponent.dropLast(3) + "m4a"
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
                var newURL = LocalFilesManager.documentDirectoryUrl
                newURL.appendPathComponent(outputURL.lastPathComponent)
                
                do {
                    if FileManager.default.fileExists(atPath: newURL.path) {
                        try FileManager.default.removeItem(atPath: newURL.path)
                    }
                    try FileManager.default.moveItem(atPath: outputURL.path, toPath: newURL.path)
                    try FileManager.default.removeItem(atPath: url.path)
                    publisher.send(newURL)
                } catch {
                    publisher.send(completion: .failure(.unableToConvertVideo(error: error)))
                }
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
