//
//  SearchViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

//import Foundation
import UIKit


final class SearchViewModel: ObservableObject {
    var url: URL {
        URL(string: Constant.youtubeUrl)!
    }
    
    let manager = AudioManager()
    
    func handlePasteSelected() {
        
        // save youtube video
        let url = UIPasteboard.general.string ?? ""
        print("Checking url: \(url)")
        loadYouTubeVideo(videoID: url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            
            // read all files
            do {
                let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let Path = documentURL.absoluteURL
                let directoryContents = try FileManager.default.contentsOfDirectory(at: Path, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                
                
                // convert
                self.manager.convertToAudio(url: directoryContents[1], completion: { url in
                    print("URL: \(url)")
                    
                    // play
                    self.manager.play2(url: url)
                })
                
                
            }
            catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func loadYouTubeVideo(videoID: String) {
        let manager = DownloadManager()
        manager.loadYouTubeVideo(videoID: videoID)
    }
}
