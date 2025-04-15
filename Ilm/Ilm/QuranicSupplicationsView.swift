//
//  QuranicSupplicationsView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 15/04/2025.
//
import SwiftUI
import Foundation

struct QuranicSupplication: Codable, Identifiable, Hashable {
    var id = UUID()
    let reference: String
    let arabic: String
    let transliteration: String
    let translation: String
    let notes: String

    private enum CodingKeys: String, CodingKey {
        case reference
        case arabic
        case transliteration
        case translation
        case notes
    }

    static func == (lhs: QuranicSupplication, rhs: QuranicSupplication) -> Bool {
        lhs.reference == rhs.reference &&
        lhs.arabic == rhs.arabic &&
        lhs.transliteration == rhs.transliteration &&
        lhs.translation == rhs.translation &&
        lhs.notes == rhs.notes
    }
}
