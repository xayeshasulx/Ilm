//
//  FullVerseView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 13/04/2025.
//
import SwiftUI

struct FullVerseView: View {
    let verse: KeyVerse
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Full Verse")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(verse.title).font(.title3).bold()
                    Text(verse.arabic).font(.title)
                    Text(verse.transliteration).italic().foregroundColor(.gray)
                    Text(verse.translation)
                }
                .padding()
            }
        }
    }
}



