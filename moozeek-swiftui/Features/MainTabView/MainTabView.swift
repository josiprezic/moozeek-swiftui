//
//  MainTabView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import SwiftUI
import Resolver

struct MainTabView: View {
    var body: some View {
        TabView {
            SongListView.resolved
                .tabItem { TabBarItem(
                    title: "Player",
                    imageSystemName: "music.note.list"
                )}
            
            PlaceholderView()
                .tabItem { TabBarItem(
                    title: "Radio",
                    imageSystemName: "dot.radiowaves.left.and.right"
                )}
            
            SearchView.resolved
                .tabItem { TabBarItem(
                    title: "Search",
                    imageSystemName: "magnifyingglass"
                )}
        }
        .accentColor(.pink)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView.resolved
    }
}


// TODO: JR Remove
struct PlaceholderView: View {
    var body: some View {
        Text("Placeholder")
    }
}
