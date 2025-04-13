//
//  KeyVersesViewModel.swift
//  Ilm
//
//  Created by Ayesha Suleman on 10/04/2025.
//
import SwiftUI
import Foundation 

class KeyVersesViewModel: ObservableObject {
    @Published var allSurahs: [SurahPosts] = []

    init() {
        loadKeyVerses()
    }

    func loadKeyVerses() {
        if let url = Bundle.main.url(forResource: "key_verses", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([SurahPosts].self, from: data)
                self.allSurahs = decodedData
            } catch {
                print("Error loading JSON: \(error)")
            }
        } else {
            print("JSON file not found.")
        }
    }

    var surahNames: [String] {
        allSurahs.map { $0.surah }
    }

    func verses(for surah: String) -> [KeyVerse] {
        allSurahs.first(where: { $0.surah == surah })?.posts ?? []
    }
}
