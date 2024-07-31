//
//  YouAreOfflineView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 07/01/2023.
//

import SwiftUI

import SwiftUI

/// A view that displays an offline message to the user.
struct YouAreOfflineView: View {
    /// The body of the `YouAreOfflineView` which contains the user interface elements.
    var body: some View {
        VStack {
            // The main title text that informs the user they are offline.
            Text("You're Offline")
                .font(.title.bold())
            // A secondary message suggesting the user turn off Airplane Mode or connect to Wi-Fi.
            Text("Turn off Airplane Mode or connect to Wi-Fi")
                .font(.body)
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

/// A preview provider for `YouAreOfflineView` to enable live preview in Xcode.
struct YouAreOfflineView_Previews: PreviewProvider {
    /// Previews the `YouAreOfflineView` for SwiftUI canvas.
    static var previews: some View {
        YouAreOfflineView()
    }
}
