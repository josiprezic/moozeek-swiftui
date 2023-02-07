//
//  ExclusiveRadioView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 07/02/2023.
//

import SwiftUI

struct ExclusiveRadioSection: View {
    var offset: CGFloat = 15.0
    let radioList: [Radio]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer().frame(width: offset)
                ForEach(radioList, content: exclusiveView)
            }
        }
    }
    
    private func exclusiveView(for radio: Radio) -> some View {
        VStack(alignment: .leading) {
            Text("Exclusive".uppercased())
                .font(.caption2)
                .opacity(0.5)
            Text(radio.name)
                .font(.headline)
            Text(radio.description)
                .font(.headline)
                .fontWeight(.regular)
                .opacity(0.5)
            Image(radio.logo)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 30, height: 300)
                .cornerRadius(10)
        }
    }
}
