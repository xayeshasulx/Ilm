//
//  AyahInsightsDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//
import SwiftUI

struct AyahInsightsDetailView: View {
    let insights: [AyahInsight]
    let selectedInsight: AyahInsight
    @Environment(\.presentationMode) var presentationMode
    @State private var expandedInsight: AyahInsight?
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(insights.indices, id: \.self) { index in
                            let insight = insights[index]
                            ZStack {
                                Color.white.ignoresSafeArea()

                                VStack(spacing: 24) {
                                    VStack(spacing: 20) {
                                        Text(insight.title)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .multilineTextAlignment(.center)

                                        let isLong = insight.translation.count > 350

                                        Group {
                                            if isLong {
                                                Text(insight.translation)
                                                    .font(.body)
                                                    .lineLimit(6)
                                                    .multilineTextAlignment(.leading)

                                                Button("Expand") {
                                                    expandedInsight = insight
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "722345"))
                                            } else {
                                                Text(insight.translation)
                                                    .font(.body)
                                                    .multilineTextAlignment(.leading)
                                            }
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
                        if let selectedIndex = insights.firstIndex(of: selectedInsight) {
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

                            Text("Ayah Insights")
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
                .sheet(item: $expandedInsight) { insight in
                    FullInsightsView(insight: insight)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

import SwiftUI

struct FullInsightsView: View {
    let insight: AyahInsight
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            // 🔝 Top Bar
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

                    Text("Full Ayah Insight")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            // 📝 Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(insight.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text(insight.translation)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding(20)
            }
        }
    }
}

