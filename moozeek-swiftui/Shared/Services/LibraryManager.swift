//
//  LibraryManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Foundation
import Combine

final class LibraryManager {
    static let loggingEnabled = false
    private let localFilesManager: LocalFilesManager
    
    init(localFilesManager: LocalFilesManager) {
        self.localFilesManager = localFilesManager
        log("Local files manager initialized")
    }
    
    func addSongToLibrary(
        songTitle: String,
        songUrl: URL,
        songExtension: String,
        thumbnailUrl: URL?,
        songID: String,
        completion: (() -> Void)? = nil
    ) {
        var errorStr: String?
        
        let dispatchGroup = DispatchGroup()
        log("Starting the required downloads for song")
        dispatchGroup.enter()
        if songExtension == "mp4" {
            localFilesManager.downloadFile(from: songUrl, filename: songTitle, extension: songExtension, completion: { error in
                errorStr = error?.localizedDescription
                dispatchGroup.leave()
            })
        }
        
        if let imageUrl = thumbnailUrl {
            dispatchGroup.enter()
            localFilesManager.downloadFile(from: imageUrl, filename: songTitle, extension: "jpg", completion: { error in
                dispatchGroup.leave()
                if error != nil  {
                    print("Error downloading thumbnail: " + error!.localizedDescription)
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            if errorStr == nil {
                print("All async download in the group completed")
                completion?()
            } else {
                self?.localFilesManager.deleteFile(withNameAndExtension: "\(songTitle).jpg")  // Delete the downloaded thumbnail if available
            }
        }
    }
    
    func getLocalSongList() -> [Song] {
        do {
            let path = LocalFilesManager.documentDirectoryUrl.absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: path,
                includingPropertiesForKeys: nil,
                options: []
            )
            
            let songList = directoryContents
                .filter { $0.lastPathComponent.split(separator: ".").last! == "m4a" }
                .map(Song.init)
            return songList
        } catch {
            log("Error: \(error)") // TODO: JR
            return []
        }
    }
    
    private func log(_ message: String) {
        guard Self.loggingEnabled else { return }
        print(message)
    }
}
