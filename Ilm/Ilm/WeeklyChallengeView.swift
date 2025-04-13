//
//  WeeklyChallengeView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 12/04/2025.
//

import SwiftUI

struct WeeklyChallengeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Image Test")
                .font(.title)

            Image("bismillah_background")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .border(Color.red) // debug border
                .background(Color.yellow.opacity(0.3))
                .padding()
        }
    }
}

