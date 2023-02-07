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
                broadcastersSection(named: "Local Broadcasters")
                broadcastersSection(named: "International Broadcasters")
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
    
    private func radioHCollectionViewItem(for radio: Radio) -> some View {
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
    
    private func broadcastersSection(named title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, collectionLeadingOffset)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer()
                        .frame(width: collectionLeadingOffset)
                    ForEach(viewModel.localBroadcasterSections) { section in
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
