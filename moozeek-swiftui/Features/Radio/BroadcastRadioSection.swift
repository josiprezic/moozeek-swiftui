//
//  BroadcastRadioSection.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/02/2023.
//

import SwiftUI

struct BroadcastRadioSection: View {
    let title: String
    let radioSections: [RadioSection]
    let collectionLeadingOffset: CGFloat = 15.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, collectionLeadingOffset)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer()
                        .frame(width: collectionLeadingOffset)
                    ForEach(radioSections) { section in
                        radioListHCollectionViewList(section)
                    }
                    Spacer()
                        .frame(width: collectionLeadingOffset)
                }
            }
        }
    }
    
    private func radioListHCollectionViewList(_ array: RadioSection) -> some View {
        VStack {
            ForEach(array.items, content: radioListHCollectionViewItem)
        }
    }
    
    private func radioListHCollectionViewItem(_ radio: Radio) -> some View {
        HStack {
            Image("gnr_logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text("Zeta FM")
                Text("From TuneIn")
                    .font(.caption2)
                    .opacity(0.5)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: Style.Image.more)
                    .renderingMode(.template)
                    .foregroundColor(.primary)
                    .frame(width: 30, height: 30)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
}
