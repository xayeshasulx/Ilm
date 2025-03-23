//
//  ContentView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 22/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            FavouritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }

            FeedView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Feed")
                }

            ReflectionsView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Reflections")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}


#Preview {
    ContentView()
}
