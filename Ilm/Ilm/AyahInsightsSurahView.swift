//
//  AyahInsightsSurahView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//
import SwiftUI

struct AyahInsightsSurahView: View {
    @ObservedObject var viewModel = AyahInsightsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isSearchFocused: Bool
    @State private var searchText = ""

    var filteredSurahs: [String] {
        if searchText.isEmpty {
            return viewModel.surahNames
        } else {
            return viewModel.surahNames.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // 🔴 Fixed Burgundy Top Bar Only
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

                    Text("Key Verses")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
            .frame(height: 56)

            // 📜 Scrollable Area (SearchBar + List)
            ScrollView {
                VStack(spacing: 12) {
                    // 🔍 Search Bar inside scroll
                    HStack {
                        TextField("Search by Surah Name", text: $searchText)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(height: 40)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .focused($isSearchFocused)

                        if isSearchFocused || !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                isSearchFocused = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    // Surah Buttons
                    LazyVStack(spacing: 12) {
                        ForEach(filteredSurahs, id: \.self) { surah in
                            NavigationLink(destination: AyahInsightsGridView(surah: surah, insights: viewModel.insights(for: surah))) {
                                Text(surah)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(hex: "D4B4AC"))
                                    .cornerRadius(16)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 80)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}



