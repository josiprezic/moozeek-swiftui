//
//  SearchViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

//import Foundation
import UIKit
import Combine


final class SearchViewModel: ObservableObject {
    var url: URL {
        URL(string: Constant.youtubeUrl)!
    }
    
    let manager = AudioManager()
    let downloadManager = DownloadManager()
    var cancellables = Set<AnyCancellable>()
    
    func handlePasteSelected() {
        
        // save youtube video
        let url = UIPasteboard.general.string ?? ""
        let videoId = String(url.suffix(11))
        
        downloadManager.downloadYouTubeVideo(videoID: videoId)
            .sink(receiveCompletion: { error in
                // handleError
            }, receiveValue: { finished in
                // handle completion
                guard finished else { return } // TODO: JR
                
                self.getLocalSongList()
                
            })
            .store(in: &cancellables)
    }
    
    func getLocalSongList() {
        do {
            let documentURL = URL(string: LocalFilesManager.documentDirectory())!
            let path = documentURL.absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
            
            let songs = directoryContents.filter {
                $0.lastPathComponent.split(separator: ".").last! == "mp4"
            }
            
            print(songs)
            // end
            
            
            // convert
            self.downloadManager.convertToAudio(url: songs.first!)
                .sink(receiveCompletion: { error in
                    // handle error
                    print(error)
                }, receiveValue: { url in
                    // handle url
                    print("URL: \(url)")
                    // play
                    self.manager.play2(url: url)
                })
                .store(in: &self.cancellables)
        } catch {
            
        }
    }
}
