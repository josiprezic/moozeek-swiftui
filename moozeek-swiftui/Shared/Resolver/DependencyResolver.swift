//
//  DependencyResolver.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Resolver

extension Resolver: ResolverRegistering, Resolving {
    public static func registerAllServices() {
        register { MainTabView() }
        
        register { LocalFilesManager() }
            .scope(.application)
        
        register { LibraryManager(localFilesManager: resolve()) }
        
        register { AudioManager() }
        
        register { DownloadManager(libraryManager: resolve()) }
        
        register { PlayerViewModel(libraryManager: resolve(), audioManager: resolve()) }
            .scope(.application)
        
        register { SongListView(viewModel: resolve()) }
        
        register { MusicPlayerBar(viewModel: resolve()) }
        
        register { MusicPlayer(viewModel: resolve()) }
        
        register { SearchViewModel(downloadManager: resolve()) }
        
        register { SearchView(viewModel: resolve()) }
        
        register { YouAreOfflineView() }
    }
}
