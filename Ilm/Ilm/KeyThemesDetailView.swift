//
//  KeyThemesDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//
import SwiftUI

struct KeyThemesDetailView: View {
    let themes: [KeyTheme]
    let selectedTheme: KeyTheme
    @Environment(\.presentationMode) var presentationMode
    @State private var expandedTheme: KeyTheme?
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(themes.indices, id: \.self) { index in
                            let theme = themes[index]
                            ZStack {
                                Color.white.ignoresSafeArea()

                                VStack(spacing: 24) {
                                    VStack(spacing: 20) {
                                        let isLong = theme.translation.count > 350

                                        Group {
                                            if isLong {
                                                Text(theme.translation)
                                                    .font(.body)
                                                    .lineLimit(6)
                                                    .multilineTextAlignment(.leading)

                                                Button("Expand") {
                                                    expandedTheme = theme
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "722345"))
                                            } else {
                                                Text(theme.translation)
                                                    .font(.body)
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 56)
                                .padding(.bottom, 40)
                            }
                            .frame(height: geo.size.height - 56)
                            .containerRelativeFrame(.vertical)
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                    .onAppear {
                        if let selectedIndex = themes.firstIndex(of: selectedTheme) {
                            currentIndex = selectedIndex
                            proxy.scrollTo(currentIndex, anchor: .top)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    ZStack {
                        Color(hex: "722345").ignoresSafeArea()
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 16)

                            Spacer()

                            Text("Key Themes & Messages")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "D4B4AC"))

                            Spacer()
                            Spacer().frame(width: 32)
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(height: 56)
                }
                .sheet(item: $expandedTheme) { theme in
                    FullThemeView(theme: theme)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

import SwiftUI

struct FullThemeView: View {
    let theme: KeyTheme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // 🔝 Top Bar
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Full Key Themes & Messages")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            // 📜 Full Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(theme.translation)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
        }
    }
}

