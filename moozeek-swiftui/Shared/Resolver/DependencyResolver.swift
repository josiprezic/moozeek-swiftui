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
        
        register { AudioManager() }
        
        register { PlayerViewModel(audioManager: resolve()) }
            .scope(.application)
        
        register { SongListView(viewModel: resolve()) }
        
        register { MusicPlayerBar(viewModel: resolve()) }
        
        register { MusicPlayer(viewModel: resolve()) }
        
        register { SearchViewModel() }
        
        register { SearchView(viewModel: resolve()) }
    }
}
