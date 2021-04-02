//
//  RootAppCoordinatorView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 4/2/21.
//

import SwiftUI

struct RootAppCoordinatorView: View {
    
    var body: some View {
        TabView {
            PlayerCoordinatorView()
                .tabItem { Label("Library", systemImage: "music.house.fill") }
            
            DownloadCoordinatorView()
                .tabItem { Label("Download", systemImage: "arrow.down.circle.fill") }
            
            SettingsCoordinatorView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

struct RootCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        RootAppCoordinatorView()
    }
}
