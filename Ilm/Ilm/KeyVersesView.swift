//
//  KeyVerses.swift
//  Ilm
//
//  Created by Ayesha Suleman on 08/04/2025.
//
import SwiftUI
import Foundation

struct SurahPosts: Codable {
    let surah: String
    let posts: [KeyVerse]
}

struct KeyVerse: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    let title: String
    let arabic: String
    let transliteration: String
    let translation: String

    private enum CodingKeys: String, CodingKey {
        case title, arabic, transliteration, translation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.arabic = try container.decode(String.self, forKey: .arabic)
        self.transliteration = try container.decode(String.self, forKey: .transliteration)
        self.translation = try container.decode(String.self, forKey: .translation)
    }

    init(title: String, arabic: String, transliteration: String, translation: String) {
        self.title = title
        self.arabic = arabic
        self.transliteration = transliteration
        self.translation = translation
    }

    static func == (lhs: KeyVerse, rhs: KeyVerse) -> Bool {
        lhs.title == rhs.title &&
        lhs.arabic == rhs.arabic &&
        lhs.transliteration == rhs.transliteration &&
        lhs.translation == rhs.translation
    }
}
