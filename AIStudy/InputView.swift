//
//  InputView.swift
//  AIStudy
//
//  Created by Anmol Varshney on 16/05/26.
//


import SwiftUI
import PhotosUI

struct InputView: View {

    @Binding var inputText: String

    @Binding var selectedPhoto: PhotosPickerItem?

    let onSend: () -> Void

    var body: some View {

        VStack(spacing: 12) {

            Divider()
                .overlay(.white.opacity(0.1))

            HStack(spacing: 12) {

                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images
                ) {

                    ZStack {

                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 46, height: 46)

                        Image(systemName: "photo")
                            .foregroundStyle(.white)
                            .font(.title3)
                    }
                }

                HStack {

                    TextField(
                        "Ask anything...",
                        text: $inputText,
                        axis: .vertical
                    )
                    .foregroundStyle(.white)
                    .lineLimit(1...5)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    Color.white.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 22
                    )
                )

                Button(action: onSend) {

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

                        Image(systemName: "arrow.up")
                            .foregroundStyle(.white)
                            .font(.headline)
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
    }
}