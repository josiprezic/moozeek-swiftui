//
//  RadioView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 09/01/2023.
//

import SwiftUI

struct RadioView: View {
    @StateObject var viewModel: RadioViewModel
    
    @State private var showDetails: Bool = false
    
    let collectionLeadingOffset: CGFloat = 15.0
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isOnline {
                    contentView
                } else {
                    offlineView
                }
                musicPlayerBar
            }
            .navigationTitle("Radio")
        }
        .fullScreenCover(isPresented: $showDetails) { MusicPlayer.resolved }
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ExclusiveRadioSection(radioList: viewModel.exclusiveSection)
                BroadcastRadioSection(title: "Local Broadcasters", radioSections: viewModel.localBroadcasterSections)
                BroadcastRadioSection(title: "International Broadcasters", radioSections: viewModel.internationalBroadcasterSections)
            }
        }
        .padding(.bottom, -8)
    }
    
    private var offlineView: some View {
        YouAreOfflineView()
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar.resolved
            .onTapGesture(perform: onMusicPlayerBarTapGesture)
            .gesture(dragGesture)
    }
    
    // MARK: - Drag gesture
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded(onDragGestureEnded)
    }
    
    private func onMusicPlayerBarTapGesture() {
        withAnimation {
            showDetails.toggle()
        }
    }
    
    private func onDragGestureEnded(_ value: DragGesture.Value) {
        if value.translation.height < 20 {
            showDetails = true
        } else if value.translation.height > 60 {
            showDetails = false
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView.resolved
    }
}

// TODO: JR MOVE
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
