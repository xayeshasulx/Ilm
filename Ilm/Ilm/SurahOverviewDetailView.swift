//
//  SurahOverviewDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//

import SwiftUI

struct SurahOverviewDetailView: View {
    let overviews: [SurahOverview]
    let selectedOverview: SurahOverview
    @Environment(\.presentationMode) var presentationMode
    @State private var expandedOverview: SurahOverview?
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(overviews.indices, id: \.self) { index in
                            let overview = overviews[index]
                            ZStack {
                                Color.white.ignoresSafeArea()

                                VStack(spacing: 24) {
                                    let isLong = overview.translation.count > 350

                                    Group {
                                        if isLong {
                                            Text(overview.translation)
                                                .font(.body)
                                                .lineLimit(6)
                                                .multilineTextAlignment(.leading)

                                            Button("Expand") {
                                                expandedOverview = overview
                                            }
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex: "722345"))
                                        } else {
                                            Text(overview.translation)
                                                .font(.body)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
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
                        if let selectedIndex = overviews.firstIndex(of: selectedOverview) {
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
                }
                .sheet(item: $expandedOverview) { overview in
                    FullSurahOverviewView(overview: overview)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct FullSurahOverviewView: View {
    let overview: SurahOverview
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Full Surah Overview")
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
                VStack(alignment: .leading, spacing: 24) {
                    Text(overview.translation)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding(20)
            }
        }
    }
}
