//
//  LibraryManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Foundation

// TODO: JR To be refactored
final class LibraryManager {
    func addSongToLibrary(songTitle: String, songUrl: URL, songExtension: String , thumbnailUrl: URL?, songID: String, completion: (() -> Void)? = nil) {
        var errorStr: String?
        
        let dispatchGroup = DispatchGroup()  // To keep track of the async download group
        print("Starting the required downloads for song")
        dispatchGroup.enter()
        if songExtension == "mp4" {
            LocalFilesManager.downloadFile(from: songUrl, filename: songTitle, extension: songExtension, completion: { error in
                errorStr = error?.localizedDescription
                dispatchGroup.leave()
            })
        }
        
        if let imageUrl = thumbnailUrl {
            dispatchGroup.enter()
            LocalFilesManager.downloadFile(from: imageUrl, filename: songTitle, extension: "jpg", completion: { error in
                dispatchGroup.leave()
                if error != nil  {
                    print("Error downloading thumbnail: " + error!.localizedDescription)
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {  // All async download in the group completed
            if errorStr == nil {
                print("All async download in the group completed")
                let duration = LocalFilesManager.extractDurationForSong(songID: songID, songExtension: "mp4")
                completion?()
            } else {
                _ = LocalFilesManager.deleteFile(withNameAndExtension: "\(songID).jpg")  // Delete the downloaded thumbnail if available
            }
        }
    }
}
