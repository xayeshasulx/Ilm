//
//  QuranicSupplicationsViewModel.swift
//  Ilm
//
//  Created by Ayesha Suleman on 15/04/2025.
//
import Foundation
import SwiftUI

class QuranicSupplicationsViewModel: ObservableObject {
    @Published var supplications: [QuranicSupplication] = []

    init() {
        loadSupplications()
    }

    private func loadSupplications() {
        guard let url = Bundle.main.url(forResource: "supplications", withExtension: "json") else {
            print("supplications.json not found.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([QuranicSupplication].self, from: data)
            DispatchQueue.main.async {
                self.supplications = decoded
                print("Loaded \(decoded.count) supplications")
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}

