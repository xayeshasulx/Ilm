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
    @State private var currentIndex: Int = 0
    @State private var itemOffsets: [Int: CGFloat] = [:]

    let topBarHeight: CGFloat = 56
    let labelBarHeight: CGFloat = 64

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // 🔝 Top Bar
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
                .frame(height: topBarHeight)

                // 🏷️ Category + Surah
                if shuffledFeed.indices.contains(currentIndex) {
                    let current = shuffledFeed[currentIndex]
                    VStack(spacing: 4) {
                        Text(current.categoryLabel)
                            .font(.caption)
                            .foregroundColor(Color(hex: "722345"))
                            .fontWeight(.medium)
                        Text(current.surahName)
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .frame(height: labelBarHeight)
                } else {
                    Color.clear.frame(height: labelBarHeight)
                }

                // 🔄 Scrollable Feed
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(shuffledFeed.indices, id: \.self) { index in
                                let item = shuffledFeed[index]

                                ZStack {
                                    Color.white.ignoresSafeArea()

                                    VStack(spacing: 24) {
                                        if let verse = item.keyVerse {
                                            verseView(verse)
                                        } else {
                                            textBlock(item.plainText)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 40)
                                }
                                .frame(height: geo.size.height - topBarHeight - labelBarHeight)
                                .containerRelativeFrame(.vertical)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: FeedIndexPreferenceKey.self, value: [index: geo.frame(in: .global).minY])
                                    }
                                )
                                .id(index)
                            }
                        }
                        .scrollTargetLayout()
                        .onPreferenceChange(FeedIndexPreferenceKey.self) { offsets in
                            itemOffsets = offsets
                            updateCurrentIndex(screenMidY: geo.frame(in: .global).midY)
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .onAppear {
                        generateShuffledFeed()
                        proxy.scrollTo(0)
                        currentIndex = 0
                    }
                    .onChange(of: shuffledFeed) {
                        if !shuffledFeed.isEmpty {
                            proxy.scrollTo(0)
                            currentIndex = 0
                        }
                    }
                }
            }
        }
        .sheet(item: $expandedItem) { item in
            if let verse = item.keyVerse {
                FullVerseView(verse: verse)
            } else {
                FullTextView(title: item.categoryLabel, text: item.plainText)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private func updateCurrentIndex(screenMidY: CGFloat) {
        let closest = itemOffsets.min(by: {
            abs($0.value - screenMidY) < abs($1.value - screenMidY)
        })?.key ?? 0

        if closest != currentIndex {
            currentIndex = closest
        }
    }

    func generateShuffledFeed() {
        var allItems: [FeedItem] = []

        for post in keyVersesVM.allSurahs {
            allItems += post.posts.map { FeedItem(keyVerse: $0, surahName: post.surah, categoryLabel: "Key Verses") }
        }

        for post in ayahInsightsVM.allSurahs {
            allItems += post.posts.map { FeedItem(ayahInsight: $0, surahName: post.surah, categoryLabel: "Ayah Insights") }
        }

        for post in keyThemesVM.allSurahs {
            allItems += post.posts.map { FeedItem(keyTheme: $0, surahName: post.surah, categoryLabel: "Key Themes & Messages") }
        }

        for post in surahOverviewVM.allSurahs {
            allItems += post.posts.map { FeedItem(surahOverview: $0, surahName: post.surah, categoryLabel: "Surah Overview") }
        }

        shuffledFeed = allItems.shuffled()
    }

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

            let isLong = verse.translation.count > 350
            Group {
                if isLong {
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

// MARK: - Offset PreferenceKey

struct FeedIndexPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}







struct FullTextView: View {
    var title: String
    var text: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            ScrollView {
                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
        }
    }
}


#Preview {
    FeedView()
}
