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
                        Image(systemName: "text.justify")
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
            .tint(Color(hex: "722345")) // Apply custom colour
        }
    }

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

