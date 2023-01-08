//
//  SearchView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        if Reachability.isConnected {
            VStack {
                Spacer()
                pasteButton
                Spacer()
                title
                description
                Spacer()
            }
        } else {
            YouAreOfflineView()
        }
    }
    
    private var pasteButton: some View {
        Button(
            action: viewModel.handlePasteSelected,
            label: {
                HStack {
                    Text("Paste")
                    Image(systemName: "doc.on.clipboard.fill")
                }
                .font(.system(size: 50))
                .padding(20)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        )
    }
    
    private var title: some View {
        Text(viewModel.titleText)
            .font(.title)
            .padding(.bottom, 5)
    }
    
    private var description: some View {
        Text(.init(viewModel.descriptionText))
            .font(.body)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView.resolved
    }
}
