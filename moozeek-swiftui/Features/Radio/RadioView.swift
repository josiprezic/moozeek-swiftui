//
//  RadioView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/01/2023.
//

import SwiftUI

struct RadioView: View {
    var body: some View {
        if Reachability.isConnected {
            Text("Radio View")
                .font(.title)
        } else {
            YouAreOfflineView()
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView()
    }
}
