//
//  ContentView.swift
//  moozeek-swiftui
//
//  Created by Josip Rezić on 3/28/21.
//

import SwiftUI

struct MusicPlayerBar: View {
    
    let namespace: Namespace.ID
    
    var body: some View {
        HStack {
        Image("gnr_logo")
            .resizable()
            .frame(width: 50, height: 50)
            .cornerRadius(5)
            .padding()
            .matchedGeometryEffect(id: "animation", in: namespace)
            
            Text("Welcome to the Jungle")
                .font(.headline)
            
        Spacer()
            
            Image(systemName: "play.fill")
                .padding()
            
            Image(systemName: "forward.fill")
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color.gray)
    }
}

struct MusicPlayer: View {
    
    let namespace: Namespace.ID
    
    var body: some View {
        VStack {
            Image("gnr_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .padding(40)
                .matchedGeometryEffect(id: "animation", in: namespace)
            
            Text("Guns N'Roses - Welcome to the Jungle")
                .font(.system(size: 20))
                .bold()
                .lineLimit(1)
                .padding()
            
//            Slider(value: .constant(0.5))
//                .padding()
                
            Spacer()
           
            HStack {
                Image(systemName: "backward.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .padding()
                
                Image(systemName: "play.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .padding()
                
                Image(systemName: "forward.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .padding()
                
                
            }
            .frame(width: .infinity)
            .padding(30)
            
        }
        .frame(width: .infinity, height: .infinity)
        .background(Color.gray.opacity(0.4))
        .ignoresSafeArea(edges: .top)
        
    }
    
}

struct ContentView: View {
    
    @Namespace private var namespace
    @State private var showDetails: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            if showDetails {
                MusicPlayer(namespace: namespace)
            } else {
                MusicPlayerBar(namespace: namespace)
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height < 0 {
                            // up
                            withAnimation(.spring()) {
                                showDetails = true
                            }
                        }
                        
                        if value.translation.height > 0 {
                            // down
                            withAnimation(.spring()) {
                                showDetails = false
                            }
                        }
                    }
        )
//        .onTapGesture {
//            withAnimation(.spring()) {
//                showDetails.toggle()
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
