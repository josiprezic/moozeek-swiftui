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
    
    init(downloadManager: DownloadManager) {
        self.downloadManager = downloadManager
    }
    
    func handlePasteSelected() {
        let pasteboardContent = UIPasteboard.general.string ?? ""
        downloadManager.downloadYouTubeSong(from: pasteboardContent)
    }
}
