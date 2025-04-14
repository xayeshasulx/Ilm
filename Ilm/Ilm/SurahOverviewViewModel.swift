//
//  SurahOverviewViewModel.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//

import Foundation

class SurahOverviewViewModel: ObservableObject {
    @Published var allSurahs: [SurahOverviewPost] = []

    init() {
        loadSurahOverviews()
    }

    func loadSurahOverviews() {
        if let url = Bundle.main.url(forResource: "surah_overview", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([SurahOverviewPost].self, from: data)
                self.allSurahs = decodedData
            } catch {
                print("Error loading Surah Overviews JSON: \(error)")
            }
        }
    }

    var surahNames: [String] {
        allSurahs.map { $0.surah }
    }

    func overviews(for surah: String) -> [SurahOverview] {
        allSurahs.first(where: { $0.surah == surah })?.posts ?? []
    }
}
