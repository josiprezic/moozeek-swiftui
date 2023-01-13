//
//  RadioView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/01/2023.
//

import SwiftUI

struct RadioView: View {
    var body: some View {
        NavigationView {
            VStack {
                if Reachability.isConnected {
                    ScrollView {
                        ScrollView(.horizontal) {
                            HStack {
                                radioHCollectionView
                                radioHCollectionView
                                radioHCollectionView
                                radioHCollectionView
                            }
                            
                        }
//                        Text("Radio View")
                    }
                } else {
                    YouAreOfflineView()
                }
            }
            .navigationTitle("Radio")
        }
    }
    
    private var radioHCollectionView: some View {
        VStack(alignment: .leading) {
            Text("Exclusive")
                .font(.callout)
            Text("Apple Music 1")
                .font(.headline)
            Text("The new music that matters.")
                .font(.headline)
            Image("gnr_logo")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 50, height: 300)
                .cornerRadius(10)
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView.resolved
    }
}
