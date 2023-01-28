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
    
    var body: some View {
        NavigationView {
            VStack {
                if Reachability.isConnected {
                    contentView
                } else {
                    YouAreOfflineView()
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
                exclusiveSection
                broadcastersSection(named: "Local Broadcasters")
                broadcastersSection(named: "International Broadcasters")
            }
        }
        .padding(.bottom, -8)
    }
    
    private var musicPlayerBar: some View {
        MusicPlayerBar.resolved
            .onTapGesture(perform: onMusicPlayerBarTapGesture)
            .gesture(dragGesture)
    }
    
    private var exclusiveSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                radioHCollectionViewItem
                radioHCollectionViewItem
                radioHCollectionViewItem
                radioHCollectionViewItem
            }
        }
    }
    
    private var radioHCollectionViewItem: some View {
        VStack(alignment: .leading) {
            Text("Exclusive".uppercased())
                .font(.caption2)
                .opacity(0.5)
            Text("Apple Music 1")
                .font(.headline)
            Text("The new music that matters.")
                .font(.headline)
                .fontWeight(.regular)
                .opacity(0.5)
            Image("gnr_logo")
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    radioListHCollectionViewList
                    radioListHCollectionViewList
                    radioListHCollectionViewList
                }
            }
        }
    }
    
    private var radioListHCollectionViewList: some View {
        VStack {
            radioListHCollectionViewItem
            radioListHCollectionViewItem
            radioListHCollectionViewItem
        }
    }
    
    private var radioListHCollectionViewItem: some View {
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
