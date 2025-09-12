//
//  ContentView.swift
//  RAVE
//
//  Created by Parth Sharma on 12/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            
            TopClubsView()
                .tabItem {
                    Image(systemName: "crown.fill")
                    Text("Top Clubs")
                }
            
            GroupsView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Groups")
                }
            
            AlertsView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Alerts")
                }
        }
        .tint(.ravePurple)
        .preferredColorScheme(.dark)
        .background(Color.darkBackground.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
