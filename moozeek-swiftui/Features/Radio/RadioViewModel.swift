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
    
    var localBroadcasters: [Radio] {
        Array(repeating: Radio(), count: 9)
    }
    
    var internationalBroadcasters: [Radio] {
        Array(repeating: Radio(), count: 9)
    }
}
