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
    
    static let didDownloadPublisher = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(libraryManager: LibraryManager) {
        self.libraryManager = libraryManager
    }
    
    func downloadYouTubeSong(from urlString: String) {
        let videoId = getVideoId(from: urlString)
        downloadYouTubeVideo(videoID: videoId)
            .sink(receiveCompletion: { completion in
                // TODO: JR handle
            }, receiveValue: { _ in
                Task { [weak self] in
                    let path = LocalFilesManager.documentDirectoryUrl.absoluteURL
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
                    
                    let filesToConvert = directoryContents.filter {
                        $0.lastPathComponent.split(separator: ".").last! == "mp4"
                    }
                    
                    filesToConvert.forEach { cos in
                        let name: String = "\(cos.lastPathComponent.split(separator: ".").first ?? "\(UUID().uuidString)")"
                        let destinationUrl = cos.deletingLastPathComponent().appendingPathComponent(name + ".m4a")
                        ConverterManager.shared.convertMP4ToM4A(mp4URL: cos, m4aURL: destinationUrl, completion: { _, _ in print("DONE!") })
                        
                        ConverterManager.shared.extractThumbnail(from: cos, completion: { image, _ in
                            print("ALSO DONE!")
                            if let image {
                                self?.saveImage(image, to: .documentDirectory, with: name)
                            }
                        })

                    }
                }
            })
            .store(in: &cancellables)
    }
    
    func saveImage(_ image: UIImage, to directory: FileManager.SearchPathDirectory, with name: String) -> URL? {
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Error converting image to data")
            return nil
        }
        
        // Create a URL for the destination
        let fileManager = FileManager.default
        guard let directoryURL = fileManager.urls(for: directory, in: .userDomainMask).first else {
            print("Error accessing directory")
            return nil
        }
        
        let fileURL = directoryURL.appendingPathComponent("\(name).jpg")
        
        // Write the data to the file system
        do {
            try imageData.write(to: fileURL)
            print("Image saved successfully at \(fileURL)")
            return fileURL
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }

    
    private func getVideoId(from urlString: String) -> String {
        // TODO: JR add missing checks
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
                thumbnailUrl: video.thumbnailURLs?[video.thumbnailURLs!.count/2],
                songID: videoID
            ) {
                publisher.send(true)
            }
        }
        
        return publisher.eraseToAnyPublisher()
    }
}


// TODO: JR move audio converter

import AVFoundation
import UIKit

class ConverterManager {
    static let shared = ConverterManager()
    
    private init() {}
    
    func convertMP4ToM4A(mp4URL: URL, m4aURL: URL, completion: @escaping (Bool, Error?) -> Void) {
        let asset = AVURLAsset(url: mp4URL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completion(false, NSError(domain: "ConverterManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot create export session"]))
            return
        }
        
        exportSession.outputFileType = .m4a
        exportSession.outputURL = m4aURL
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(true, nil)
            case .failed, .cancelled:
                completion(false, exportSession.error)
            default:
                completion(false, NSError(domain: "ConverterManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
            }
        }
    }
    
    func extractThumbnail(from mp4URL: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        let asset = AVAsset(url: mp4URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        var actualTime = CMTime.zero
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            let image = UIImage(cgImage: cgImage)
            completion(image, nil)
        } catch {
            completion(nil, error)
        }
    }
}

