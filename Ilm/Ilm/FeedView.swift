//
//  FeedView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 23/03/2025.
//
import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel = KeyVersesViewModel()
    @State private var expandedVerse: KeyVerse?

    var allVerses: [KeyVerse] {
        viewModel.allSurahs.flatMap { $0.posts }
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(allVerses) { verse in
                        ZStack {
                            Color.white

                            VStack(spacing: 24) {
                                VStack(spacing: 20) {
                                    Text(verse.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)

                                    Text(verse.arabic)
                                        .font(.title)
                                        .multilineTextAlignment(.center)

                                    Text(verse.transliteration)
                                        .italic()
                                        .foregroundColor(.gray)

                                    let isLong = verse.translation.count > 350

                                    Group {
                                        if isLong {
                                            Text(verse.translation)
                                                .font(.body)
                                                .lineLimit(6)
                                                .multilineTextAlignment(.leading)

                                            Button("Expand") {
                                                expandedVerse = verse
                                            }
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex: "722345"))
                                        } else {
                                            Text(verse.translation)
                                                .font(.body)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 20)

                                Spacer()
                            }
                            .frame(height: geo.size.height - 56) // remove extra bottom space
                        }
                        .containerRelativeFrame(.vertical)
                        .ignoresSafeArea()
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .overlay(alignment: .top) {
                ZStack {
                    Color(hex: "722345").ignoresSafeArea()
                    Text("Feed")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))
                }
                .frame(height: 56)
            }
            .sheet(item: $expandedVerse) { verse in
                FullVerseView(verse: verse)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FeedView()
}
