//
//  SurahOverviewView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//

import Foundation

struct SurahOverviewPost: Codable {
    let surah: String
    let posts: [SurahOverview]
}

struct SurahOverview: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    let translation: String

    private enum CodingKeys: String, CodingKey {
        case translation = "text"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.translation = try container.decode(String.self, forKey: .translation)
    }

    init(translation: String) {
        self.translation = translation
    }

    static func == (lhs: SurahOverview, rhs: SurahOverview) -> Bool {
        lhs.translation == rhs.translation
    }
}

