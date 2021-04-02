//
//  PlayerCoordinatorView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct PlayerCoordinatorView: View {
    
    var body: some View {
        PlayerView(viewModel: PlayerViewModel())
    }
}

// MARK: - Previews -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerCoordinatorView()
    }
}
