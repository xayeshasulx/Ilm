//
//  PostsGridView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 10/04/2025.
//
import SwiftUI

struct KeyVersesGridView: View {
    let surah: String
    let verses: [KeyVerse]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geo in
            let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            let itemWidth = geo.size.width / 3

            VStack(spacing: 0) {
                // 🔝 Top Bar
                ZStack(alignment: .bottom) {
                    Color(hex: "722345")
                        .ignoresSafeArea(edges: .top)

                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 16)

                        Spacer()

                        Text("Key Verses")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "D4B4AC"))

                        Spacer()
                        Spacer().frame(width: 32)
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: 56)

                Text(surah)
                    .font(.subheadline)
                    .padding(.top, 10)

                // 🔳 Grid of Verses
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(verses) { verse in
                            verseGridItem(verse: verse, itemWidth: itemWidth)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    // ✅ Break into subview for type-checking performance
    @ViewBuilder
    private func verseGridItem(verse: KeyVerse, itemWidth: CGFloat) -> some View {
        NavigationLink(destination: KeyVersesDetailView(verses: [verse])) {
            VStack(spacing: 0) {
                Text(verse.title)
                    .font(.caption2)
                    .lineLimit(1)
                    .padding(4)

                Text(verse.translation)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.center)
                    .padding(6)
            }
            .frame(width: itemWidth, height: itemWidth)
            .background(Color.white)
            .border(Color.black, width: 0.5)
        }
    }
}

