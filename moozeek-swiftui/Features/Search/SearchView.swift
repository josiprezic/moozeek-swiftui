//
//  SearchView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        WebView(url: viewModel.url)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView.resolved
    }
}
