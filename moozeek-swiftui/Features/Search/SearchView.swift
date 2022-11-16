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
        Button(
            action: {
                viewModel.handlePasteSelected()
            },
            label: {
                HStack {
                    Text("Paste")
                    Image(systemName: "doc.on.clipboard.fill")
                }
                .font(.system(size: 50))
                
            }
        )
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView.resolved
    }
}
