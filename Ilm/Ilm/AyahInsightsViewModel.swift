//
//  AyahInsightsViewModel.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//
import SwiftUI
import Foundation

class AyahInsightsViewModel: ObservableObject {
    @Published var allSurahs: [AyahInsightPost] = []

    init() {
        loadAyahInsights()
    }

    func loadAyahInsights() {
        if let url = Bundle.main.url(forResource: "ayah_insights", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([AyahInsightPost].self, from: data)
                self.allSurahs = decodedData
            } catch {
                print("Error loading Ayah Insights JSON: \(error)")
            }
        } else {
            print("ayah_insights.json not found in bundle.")
        }
    }

    var surahNames: [String] {
        allSurahs.map { $0.surah }
    }

    func insights(for surah: String) -> [AyahInsight] {
        allSurahs.first(where: { $0.surah == surah })?.posts ?? []
    }
}

