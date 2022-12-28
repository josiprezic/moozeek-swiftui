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
        ScrollView {
            VStack {
                spacer
                pasteButton
                spacer
                title
                description
            }
        }
    }
    
    private var spacer: some View {
        Spacer()
            .frame(height: 100)
    }
    
    private var title: some View {
        Text(viewModel.titleText)
            .font(.system(size: 40))
    }
    
    private var description: some View {
        Text(.init(viewModel.descriptionText))
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView.resolved
    }
}
