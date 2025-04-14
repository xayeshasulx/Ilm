//
//  AyahInsightsView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//

import SwiftUI
import Foundation

struct AyahInsightPost: Codable {
    let surah: String
    let posts: [AyahInsight]
}

struct AyahInsight: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    let title: String
    let translation: String

    private enum CodingKeys: String, CodingKey {
        case title = "reference"
        case translation = "text"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.translation = try container.decode(String.self, forKey: .translation)
    }

    init(title: String, translation: String) {
        self.title = title
        self.translation = translation
    }

    static func == (lhs: AyahInsight, rhs: AyahInsight) -> Bool {
        lhs.title == rhs.title &&
        lhs.translation == rhs.translation
    }
}
