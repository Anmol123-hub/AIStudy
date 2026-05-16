//
//  HeaderView.swift
//  AIStudy
//
//  Created by Anmol Varshney on 16/05/26.
//


import SwiftUI

struct HeaderView: View {

    var body: some View {

        HStack(spacing: 14) {

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: "brain.head.profile")
                    .foregroundStyle(.white)
                    .font(.title2)
            }

            VStack(alignment: .leading, spacing: 4) {

                Text("Study Buddy AI")
                    .font(.headline)
                    .foregroundStyle(.white)

                HStack(spacing: 6) {

                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)

                    Text("Offline • Gemma AI")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.95))
    }
}

#Preview {

    ZStack {

        Color.black
            .ignoresSafeArea()

        HeaderView()
    }
}