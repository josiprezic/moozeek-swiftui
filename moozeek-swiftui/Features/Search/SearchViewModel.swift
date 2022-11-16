//
//  SearchViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Foundation

final class SearchViewModel: ObservableObject {
    var url: URL {
        URL(string: Constant.youtubeUrl)!
    }
}
