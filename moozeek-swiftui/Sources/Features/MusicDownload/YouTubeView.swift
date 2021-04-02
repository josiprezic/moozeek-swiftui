//
//  YouTubeView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 4/2/21.
//

import SwiftUI

struct YouTubeView: View {
    
    var body: some View {
        Webview(url: URL(string: "https://youtube.com")!) // TODO: JR
    }
}


struct YouTubeView_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeView()
    }
}
