//
//  YouAreOfflineView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 07/01/2023.
//

import SwiftUI

struct YouAreOfflineView: View {
    var body: some View {
        VStack {
            Text("You're Offline")
                .font(.title.bold())
            Text("Turn off Airplane Mode or connect to Wi-Fi")
                .font(.body)
        }
    }
}

struct YouAreOfflineView_Previews: PreviewProvider {
    static var previews: some View {
        YouAreOfflineView.resolved
    }
}
