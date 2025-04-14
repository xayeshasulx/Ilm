//
//  SurahOverviewGridView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//

import SwiftUI

struct SurahOverviewGridView: View {
    let surah: String
    let overviews: [SurahOverview]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geo in
            let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            let itemWidth = geo.size.width / 3

            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Color(hex: "722345")
                        .ignoresSafeArea(edges: .top)

                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 16)

                        Spacer()

                        Text("Surah Overviews")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "D4B4AC"))

                        Spacer()
                        Spacer().frame(width: 32)
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: 56)

                Text(surah)
                    .font(.subheadline)
                    .padding(.top, 10)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(overviews) { item in
                            overviewGridItem(overview: item, itemWidth: itemWidth)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    private func overviewGridItem(overview: SurahOverview, itemWidth: CGFloat) -> some View {
        NavigationLink(destination: SurahOverviewDetailView(overviews: overviews, selectedOverview: overview)) {
            VStack(spacing: 0) {
                Text(overview.translation)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(6)
                    .multilineTextAlignment(.center)
                    .padding(6)
            }
            .frame(width: itemWidth, height: itemWidth)
            .background(Color.white)
            .border(Color.black, width: 0.5)
        }
    }
}
