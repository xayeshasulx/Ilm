//
//  PostDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 10/04/2025.
//
import SwiftUI

struct KeyVersesDetailView: View {
    let verses: [KeyVerse]
    @Environment(\.presentationMode) var presentationMode
    @State private var expandedVerse: KeyVerse?

    var body: some View {
        VStack(spacing: 0) {
            // 🔝 Custom Top Bar
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

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

            // 📜 Scrollable content, no snap
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(verses, id: \.self) { verse in
                        VStack(alignment: .leading, spacing: 20) {
                            Text(verse.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)

                            Text(verse.arabic)
                                .font(.title)
                                .multilineTextAlignment(.center)

                            Text(verse.transliteration)
                                .italic()
                                .foregroundColor(.gray)

                            let isLong = verse.translation.count > 350

                            if isLong {
                                Text(verse.translation)
                                    .lineLimit(6)
                                    .multilineTextAlignment(.leading)

                                Button("Expand") {
                                    expandedVerse = verse
                                }
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "722345"))
                            } else {
                                Text(verse.translation)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 60)
            }
        }
        .sheet(item: $expandedVerse) { verse in
            FullVerseView(verse: verse)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}










