//
//  FeedView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 23/03/2025.
//
import SwiftUI

struct FeedView: View {
    @ObservedObject var keyVersesVM = KeyVersesViewModel()
    @ObservedObject var ayahInsightsVM = AyahInsightsViewModel()
    @ObservedObject var keyThemesVM = KeyThemesViewModel()
    @ObservedObject var surahOverviewVM = SurahOverviewViewModel()

    @State private var shuffledFeed: [FeedItem] = []
    @State private var expandedItem: FeedItem?

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(shuffledFeed.indices, id: \.self) { index in
                        let item = shuffledFeed[index]

                        ZStack {
                            Color.white.ignoresSafeArea()

                            GeometryReader { innerGeo in
                                VStack(spacing: 24) {
                                    // 🏷️ Category + Surah (TOP AREA UNDER NAV)
                                    VStack(spacing: 4) {
                                        Text(item.categoryLabel)
                                            .font(.headline)
                                            .foregroundColor(Color(hex: "A46A79"))
                                            .fontWeight(.medium)

                                        Text(item.surahName)
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex: "A46A79"))
                                    }

                                    // 📝 Content Block
                                    if let verse = item.keyVerse {
                                        verseView(verse)
                                    } else if let insight = item.ayahInsight {
                                        insightView(insight)
                                    } else {
                                        textBlock(item.plainText)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 56) // height of top nav bar
                                .padding(.bottom, 40)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .frame(height: geo.size.height - 56) // full screen minus nav bar
                        .containerRelativeFrame(.vertical)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .overlay(alignment: .top) {
                // 🔝 NAV BAR
                ZStack {
                    Color(hex: "722345").ignoresSafeArea()
                    HStack {
                        Button(action: generateShuffledFeed) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 16)

                        Spacer()

                        Text("Feed")
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
            .onAppear(perform: generateShuffledFeed)
            .sheet(item: $expandedItem) { item in
                if let verse = item.keyVerse {
                    FullVerseView(verse: verse)
                } else {
                    FullTextView(title: item.categoryLabel, text: item.plainText)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func generateShuffledFeed() {
        var allItems: [FeedItem] = []

        for post in keyVersesVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(keyVerse: $0, surahName: post.surah, categoryLabel: "Key Verses")
            }
        }

        for post in ayahInsightsVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(ayahInsight: $0, surahName: post.surah, categoryLabel: "Ayah Insights")
            }
        }

        for post in keyThemesVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(keyTheme: $0, surahName: post.surah, categoryLabel: "Key Themes & Messages")
            }
        }

        for post in surahOverviewVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(surahOverview: $0, surahName: post.surah, categoryLabel: "Surah Overview")
            }
        }

        shuffledFeed = allItems.shuffled()
    }

    // MARK: - VIEWS

    @ViewBuilder
    func verseView(_ verse: KeyVerse) -> some View {
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

            if verse.translation.count > 350 {
                Text(verse.translation)
                    .font(.body)
                    .lineLimit(6)
                    .multilineTextAlignment(.leading)

                Button("Expand") {
                    expandedItem = FeedItem(keyVerse: verse)
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

    @ViewBuilder
    func insightView(_ insight: AyahInsight) -> some View {
        VStack(spacing: 20) {
            Text(insight.title)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            if insight.translation.count > 350 {
                Text(insight.translation)
                    .font(.body)
                    .lineLimit(6)
                    .multilineTextAlignment(.leading)

                Button("Expand") {
                    expandedItem = FeedItem(ayahInsight: insight)
                }
                .font(.subheadline)
                .foregroundColor(Color(hex: "722345"))
            } else {
                Text(insight.translation)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
        }
    }

    @ViewBuilder
    func textBlock(_ text: String) -> some View {
        let isLong = text.count > 350
        VStack(spacing: 16) {
            if isLong {
                Text(text)
                    .font(.body)
                    .lineLimit(6)
                    .multilineTextAlignment(.leading)

                Button("Expand") {
                    expandedItem = FeedItem(text: text)
                }
                .font(.subheadline)
                .foregroundColor(Color(hex: "722345"))
            } else {
                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}


// MARK: - FeedItem

struct FeedItem: Identifiable, Equatable {
    var id = UUID()

    var keyVerse: KeyVerse?
    var ayahInsight: AyahInsight?
    var keyTheme: KeyTheme?
    var surahOverview: SurahOverview?
    var text: String?

    var surahName: String = ""
    var categoryLabel: String = ""

    var plainText: String {
        if let text = text { return text }
        if let ayahInsight = ayahInsight { return ayahInsight.translation }
        if let keyTheme = keyTheme { return keyTheme.translation }
        if let surahOverview = surahOverview { return surahOverview.translation }
        return ""
    }

    static func ==(lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }
}


// MARK: - FeedIndexPreferenceKey

struct FeedIndexPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}


struct FullTextView: View {
    var title: String
    var text: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // 🔝 Top Bar
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Full Text")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            // 📝 Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding(20)
            }
        }
    }
}



#Preview {
    FeedView()
}
