
//  HomeView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 23/03/2025.
//
import SwiftUI

struct Verse: Codable, Hashable {
    let title: String
    let arabic: String
    let transliteration: String
    let translation: String
}

struct SurahData: Codable {
    let surah: String
    let posts: [Verse]
}

struct HomeView: View {
    let dailyVerse: Verse?

    init() {
        self.dailyVerse = Self.loadDailyVerse()
    }

    var body: some View {
        GeometryReader { geo in
            let isIpad = geo.size.width > 600

            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar(isIpad: isIpad)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            WeeklyChallengeButton(isIpad: isIpad)

                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2),
                                spacing: 20
                            ) {
                                HomeGridButton(title: "Key Verses", destination: AnyView(KeyVersesSurahView()), isIpad: isIpad)
                                HomeGridButton(title: "Key Themes & Messages", destination: AnyView(KeyThemesView()), isIpad: isIpad)
                                HomeGridButton(title: "Surah Summary", destination: AnyView(SurahSummaries()), isIpad: isIpad)
                                HomeGridButton(title: "Quranic Supplications", destination: AnyView(Supplications()), isIpad: isIpad)
                                HomeGridButton(title: "Arabic Words", destination: AnyView(ArabicWords()), isIpad: isIpad)
                                HomeGridButton(title: "Surah Insights", destination: AnyView(SurahInsights()), isIpad: isIpad)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }

    private func topBar(isIpad: Bool) -> some View {
        VStack(alignment: .leading, spacing: isIpad ? 36 : 16) {
            Text("Daily Verse")
                .font(isIpad ? .system(size: 36, weight: .semibold) : .title3)
                .foregroundColor(Color(hex: "D4B4AC"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, isIpad ? 100 : 60)

            if let verse = dailyVerse {
                VStack(alignment: .leading, spacing: isIpad ? 24 : 12) {
                    Text(verse.title)
                        .font(isIpad ? .title2 : .subheadline)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    VStack(spacing: isIpad ? 20 : 10) {
                        Text(verse.arabic)
                            .font(.system(size: isIpad ? 42 : 22))
                            .foregroundColor(Color(hex: "D4B4AC"))
                            .multilineTextAlignment(.center)

                        Text(verse.transliteration)
                            .font(isIpad ? .title3 : .caption)
                            .italic()
                            .foregroundColor(Color(hex: "D4B4AC"))
                            .multilineTextAlignment(.leading)
                    }

                    Text(verse.translation)
                        .font(isIpad ? .title3 : .caption)
                        .foregroundColor(Color(hex: "D4B4AC"))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
            } else {
                Text("Verse not found.")
                    .foregroundColor(Color(hex: "D4B4AC").opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.bottom, isIpad ? 60 : 20)
        .background(Color(hex: "722345").ignoresSafeArea(edges: .top))
    }

    static func loadDailyVerse() -> Verse? {
        guard let url = Bundle.main.url(forResource: "key_verses", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let surahs = try? JSONDecoder().decode([SurahData].self, from: data) else {
            return nil
        }

        let allVerses = surahs.flatMap { $0.posts }
        guard !allVerses.isEmpty else { return nil }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return allVerses[dayOfYear % allVerses.count]
    }
}

struct WeeklyChallengeButton: View {
    var isIpad: Bool

    var body: some View {
        NavigationLink(destination: WeeklyChallengeView()) {
            ZStack {
                Color(hex: "A46A79")
                    .cornerRadius(16)

                Image("bismillah_background")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isIpad ? 400 : 350, height: isIpad ? 90 : 70)
                    .offset(y: 4)

                Text("Weekly Challenge")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(height: isIpad ? 120 : 90)
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct HomeGridButton: View {
    var title: String
    var destination: AnyView
    var isIpad: Bool

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, minHeight: isIpad ? 120 : 90)
                .background(Color(hex: "A46A79"))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}



