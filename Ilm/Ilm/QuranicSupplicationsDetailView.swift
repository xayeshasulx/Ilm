//
//  QuranicSupplicationsDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 15/04/2025.
//
import SwiftUI

struct QuranicSupplicationsDetailView: View {
    let supplications: [QuranicSupplication]
    let selected: QuranicSupplication

    @Environment(\.presentationMode) var presentationMode
    @State private var expandedSupp: QuranicSupplication?
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(supplications.indices, id: \.self) { index in
                            let supp = supplications[index]

                            ZStack {
                                Color.white.ignoresSafeArea()

                                VStack(spacing: 24) {
                                    VStack(spacing: 20) {
                                        Text(supp.reference)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .multilineTextAlignment(.center)

                                        Text(supp.arabic)
                                            .font(.title)
                                            .multilineTextAlignment(.center)

                                        Text(supp.transliteration)
                                            .italic()
                                            .foregroundColor(.gray)

                                        let isLong = supp.translation.count > 350

                                        Group {
                                            if isLong {
                                                Text(supp.translation)
                                                    .font(.body)
                                                    .lineLimit(6)
                                                    .multilineTextAlignment(.leading)

                                                Button("Expand") {
                                                    expandedSupp = supp
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "722345"))
                                            } else {
                                                Text(supp.translation)
                                                    .font(.body)
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }

                                        if !supp.notes.isEmpty {
                                            Text(supp.notes)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 56)
                                .padding(.bottom, 40)
                            }
                            .frame(height: geo.size.height - 56)
                            .containerRelativeFrame(.vertical)
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                    .onAppear {
                        if let selectedIndex = supplications.firstIndex(of: selected) {
                            currentIndex = selectedIndex
                            proxy.scrollTo(currentIndex, anchor: .top)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    ZStack {
                        Color(hex: "722345").ignoresSafeArea()
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
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
                }
                .sheet(item: $expandedSupp) { supp in
                    FullSupplicationView(supp: supp)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct FullSupplicationView: View {
    let supp: QuranicSupplication
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
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

                    Text("Full Supplication")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(supp.reference).font(.title3).bold()
                    Text(supp.arabic).font(.title)
                    Text(supp.transliteration).italic().foregroundColor(.gray)
                    Text(supp.translation)
                    if !supp.notes.isEmpty {
                        Text(supp.notes).font(.footnote).foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
    }
}


