//
//  RadioViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 28/01/2023.
//

import Foundation

final class RadioViewModel: ViewModel, ObservableObject {
    
    var isOnline: Bool {
        Reachability.isConnected
    }
    
    var exclusiveSection: [Radio] {
        Array(repeating: Radio(), count: 9)
    }
    
    var localBroadcasterSections: [RadioSection] {
        let items = Array(repeating: Radio(), count: 3)
        let section = RadioSection(items: items)
        return Array(repeating: section, count: 3)
    }
    
    var internationalBroadcasterSections: [RadioSection] {
        let items = Array(repeating: Radio(), count: 3)
        let section = RadioSection(items: items)
        return Array(repeating: section, count: 3)
    }
}
