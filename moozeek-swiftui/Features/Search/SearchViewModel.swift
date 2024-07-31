//
//  SearchViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import UIKit

/// Protocol that defines the delegate methods for `SearchViewModel`
protocol SearchViewModelDelegate: AnyObject {
    /// Called when a song has been downloaded
    func didDownloadSong()
}

/// A view model class for managing the state and actions of the search view
final class SearchViewModel: ViewModel, ObservableObject {
    /// The download manager responsible for handling song downloads
    private let downloadManager: DownloadManager
    
    /// The title text displayed in the search view
    let titleText = "Instructions"
    
    /// The description text displayed in the search view
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
    
    /// Initializes a new instance of `SearchViewModel`
    /// - Parameter downloadManager: The download manager responsible for handling song downloads
    init(downloadManager: DownloadManager) {
        self.downloadManager = downloadManager
    }
    
    /// Handles the action when the paste button is selected
    func handlePasteSelected() {
        // Retrieve the content from the pasteboard
        let pasteboardContent = UIPasteboard.general.string ?? ""
        
        // Use the download manager to download the song from the provided URL
        downloadManager.downloadYouTubeSong(from: pasteboardContent)
    }
}
