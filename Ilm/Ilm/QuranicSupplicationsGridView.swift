//
//  QuranicSupplicationsGridView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 15/04/2025.
//
import SwiftUI

struct QuranicSupplicationsGridView: View {
    @StateObject private var viewModel = QuranicSupplicationsViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geo in
            let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            let itemWidth = geo.size.width / 3

            VStack(spacing: 0) {
                // 🔝 Top Bar
                ZStack(alignment: .bottom) {
                    Color(hex: "722345").ignoresSafeArea(edges: .top)

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

                        Text("Quranic Supplications")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "D4B4AC"))

                        Spacer()
                        Spacer().frame(width: 32)
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: 56)

                // 🔳 Grid of Supplications
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(viewModel.supplications) { supp in
                            suppGridItem(supp: supp, itemWidth: itemWidth)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    // ✅ Grid Item View
    @ViewBuilder
    private func suppGridItem(supp: QuranicSupplication, itemWidth: CGFloat) -> some View {
        NavigationLink(destination: QuranicSupplicationsDetailView(supplications: viewModel.supplications, selected: supp)) {
            VStack(spacing: 0) {
                Text(supp.reference)
                    .font(.caption2)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(4)

                Text(supp.translation)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.center)
                    .padding(6)
            }
            .frame(width: itemWidth, height: itemWidth)
            .background(Color.white)
            .border(Color.black, width: 0.5)
        }
    }
}

