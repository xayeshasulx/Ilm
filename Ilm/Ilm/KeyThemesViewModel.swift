//
//  KeyThemesViewModel.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//

import Foundation

class KeyThemesViewModel: ObservableObject {
    @Published var allSurahs: [KeyThemePost] = []

    init() {
        loadKeyThemes()
    }

    func loadKeyThemes() {
        if let url = Bundle.main.url(forResource: "key_themes_and_messages", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([KeyThemePost].self, from: data)
                self.allSurahs = decodedData
            } catch {
                print("Error loading Key Themes JSON: \(error)")
            }
        }
    }

    var surahNames: [String] {
        allSurahs.map { $0.surah }
    }

    func themes(for surah: String) -> [KeyTheme] {
        allSurahs.first(where: { $0.surah == surah })?.posts ?? []
    }
}
