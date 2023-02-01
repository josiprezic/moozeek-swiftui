//
//  Radio.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 29/01/2023.
//

import Foundation

struct Radio: Identifiable {
    let id = UUID()
    let name: String = "Radio name"
    let description = "From TuneIn"
    let logo: String = "gnr_logo"
}

struct RadioSection: Identifiable {
    let id = UUID()
    let items: [Radio]
}
