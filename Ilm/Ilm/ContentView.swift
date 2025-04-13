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
                .embedInNav()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            FavouritesView()
                .embedInNav()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }

            FeedView()
                .embedInNav()
                .tabItem {
                    Image(systemName: "text.justify")
                    Text("Feed")
                }

            ReflectionsView()
                .embedInNav()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Reflections")
                }

            SettingsView()
                .embedInNav()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .tint(Color(hex: "722345"))
        .environment(\.horizontalSizeClass, .compact) // ✅ Forces bottom tab on iPad
    }
}

// ✅ Forces navigation without sidebar on iPad
extension View {
    func embedInNav() -> some View {
        NavigationView {
            self
                .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}
#Preview {
    ContentView()
}
