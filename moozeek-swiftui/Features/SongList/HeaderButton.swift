//
//  HeaderButton.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/11/2022.
//

import SwiftUI

struct HeaderButton: View {
    let title: String
    let imageSystemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(systemName: imageSystemName)
                Text(title)
                    .textCase(.none)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .foregroundColor(.pink)
            .cornerRadius(10)
            .fontWeight(.bold)
            
        })
    }
}

struct HeaderButton_Previews: PreviewProvider {
    static var previews: some View {
        HeaderButton(title: "Play", imageSystemName: "play.fill", action: { })
    }
}
