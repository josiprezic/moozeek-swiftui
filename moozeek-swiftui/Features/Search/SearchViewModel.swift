//
//  SearchViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func didDownloadSong()
}

final class SearchViewModel: ViewModel, ObservableObject {
    private let downloadManager: DownloadManager
    
    let titleText = "Instructions"
    
    let descriptionText =
    """
    1. Go to [www.youtube.com](https://youtube.com)
    2. Search for a song.
    3. Click on Share button.
    4. Click on the Paste button in the app.
    5. Go to the Player tab.
    6. Play the song.
    7. Enjoy!
    """
    
    init(downloadManager: DownloadManager) {
        self.downloadManager = downloadManager
    }
    
    func handlePasteSelected() {
        let pasteboardContent = UIPasteboard.general.string ?? ""
        downloadManager.downloadYouTubeSong(from: pasteboardContent)
    }
}
