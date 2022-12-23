//
//  LibraryManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Foundation
import Combine

final class LibraryManager {
    static let loggingEnabled = true
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
                // Delete the downloaded thumbnail if available
                self?.localFilesManager.deleteFile(withNameAndExtension: "\(songTitle).jpg")
            }
        }
    }
    
    func getLocalSongList() -> [Song] {
        localFilesManager.getUrlsForFiles(withExtension: "m4a").map(Song.init)
    }
    
    func delete(_ song: Song) {
        let name = song.name
        localFilesManager.deleteFile(withNameAndExtension: name + ".m4a")
        localFilesManager.deleteFile(withNameAndExtension: name + ".jpg")
    }
    
    private func log(_ message: String) {
        guard Self.loggingEnabled else { return }
        print(message)
    }
}
