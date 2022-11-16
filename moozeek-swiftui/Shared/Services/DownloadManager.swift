//
//  DownloadManager.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import XCDYouTubeKit
import Combine

// TODO: JR To be refactored
final class DownloadManager {
    func loadYouTubeVideo(videoID: String) {
        print("Loading url: https://www.youtube.com/embed/\(videoID)")
        XCDYouTubeClient.default().getVideoWithIdentifier(videoID) { (video, error) in
            guard video != nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let video else { fatalError() }
            
            LibraryManager().addSongToLibrary(songTitle: video.title, songUrl: video.streamURL!, songExtension: "mp4", thumbnailUrl: video.thumbnailURLs![video.thumbnailURLs!.count/2], songID: videoID) {
                print("FINISHED ADDING TO DOCUMENTS!")
            }
        }
    }
}
