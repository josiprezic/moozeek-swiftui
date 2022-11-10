//
//  TabBarItem.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import SwiftUI

struct TabBarItem: View {
    let title: String
    let imageSystemName: String
    
    var body: some View {
        VStack {
            Image(systemName: imageSystemName)
            Text(title)
        }
    }
}
