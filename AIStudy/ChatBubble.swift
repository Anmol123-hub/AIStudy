//
//  ChatBubble.swift
//  AIStudy
//
//  Created by Anmol Varshney on 16/05/26.
//


import SwiftUI

struct ChatBubble: View {

    let message: Message

    var body: some View {

        HStack {

            if message.isUser {

                Spacer()
            }

            VStack(alignment: .leading, spacing: 10) {

                if let image = message.image {

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 180)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                        )
                }

                Text(message.text)
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        message.isUser
                        ? Color.blue
                        : Color.white.opacity(0.1)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 22
                        )
                    )
            }
            .frame(
                maxWidth: UIScreen.main.bounds.width * 0.75,
                alignment: .leading
            )

            if !message.isUser {

                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {

    ZStack {

        Color.black
            .ignoresSafeArea()

        ChatBubble(
            message: Message(
                text: "Hello",
                isUser: false
            )
        )
    }
}