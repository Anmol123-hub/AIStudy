//
//  ContentView.swift
//  AIStudy
//
//  Created by Anmol Varshney on 16/05/26.
//

import SwiftUI
import PhotosUI

struct ContentView: View {

    // MARK: - States

    @State private var messages: [Message] = [

        Message(
            text: "Hi 👋\nUpload study material or ask me anything.",
            isUser: false
        )
    ]

    @State private var inputText = ""

    @State private var selectedPhoto: PhotosPickerItem?

    @State private var selectedImage: UIImage?

    @State private var isTyping = false

    // MARK: - Services

    let gemmaService = GemmaService()

    let ocrService = OCRService()

    // MARK: - Body

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Header

                HeaderView()

                // MARK: - Chat Area

                ScrollViewReader { proxy in

                    ScrollView {

                        LazyVStack(spacing: 16) {

                            ForEach(messages) { message in

                                ChatBubble(
                                    message: message
                                )
                            }

                            // MARK: - Typing

                            if isTyping {

                                HStack {

                                    HStack(spacing: 10) {

                                        ProgressView()

                                        Text("Gemma is thinking...")
                                            .foregroundStyle(.white)
                                    }
                                    .padding()
                                    .background(
                                        Color.white.opacity(0.08)
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 20
                                        )
                                    )

                                    Spacer()
                                }
                                .padding(.horizontal)
                            }

                            Color.clear
                                .frame(height: 1)
                                .id("BOTTOM")
                        }
                        .padding(.top)
                    }
                    .onChange(of: messages.count) {

                        withAnimation {

                            proxy.scrollTo(
                                "BOTTOM",
                                anchor: .bottom
                            )
                        }
                    }
                }

                // MARK: - Input

                InputView(
                    inputText: $inputText,
                    selectedPhoto: $selectedPhoto,
                    onSend: {

                        sendTextMessage()
                    }
                )
            }
        }
        .onChange(of: selectedPhoto) {

            Task {

                if let data = try? await selectedPhoto?
                    .loadTransferable(type: Data.self),

                   let image = UIImage(data: data) {

                    selectedImage = image

                    sendImageMessage(image)
                }
            }
        }
    }
}

// MARK: - Actions

extension ContentView {

    // MARK: - Text Message

    func sendTextMessage() {

        guard !inputText.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {

            return
        }

        let prompt = inputText

        let userMessage = Message(
            text: prompt,
            isUser: true
        )

        withAnimation {

            messages.append(userMessage)
        }

        inputText = ""

        generateAIResponse(
            from: prompt
        )
    }

    // MARK: - Image Message

    func sendImageMessage(
        _ image: UIImage
    ) {

        let userMessage = Message(
            text: "📷 Uploaded Study Material",
            isUser: true,
            image: image
        )

        withAnimation {

            messages.append(userMessage)
        }

        Task {

            isTyping = true

            // MARK: - OCR

            let extractedText = await ocrService
                .extractText(from: image)

            print("OCR TEXT:")
            print(extractedText)

            // MARK: - Prompt

            let prompt = """

            You are an AI Study Buddy.

            Analyze this study material.

            Generate:
            1. Summary
            2. Important points
            3. Easy explanation
            4. Quiz questions

            Study Material:
            \(extractedText)

            """

            // MARK: - Gemma Response

            let response = await gemmaService
                .generateResponse(
                    from: prompt
                )

            isTyping = false

            let aiMessage = Message(
                text: response,
                isUser: false
            )

            withAnimation {

                messages.append(aiMessage)
            }
        }
    }

    // MARK: - AI Response

    func generateAIResponse(
        from prompt: String
    ) {

        Task {

            isTyping = true

            let response = await gemmaService
                .generateResponse(
                    from: prompt
                )

            isTyping = false

            let aiMessage = Message(
                text: response,
                isUser: false
            )

            withAnimation {

                messages.append(aiMessage)
            }
        }
    }
}

#Preview {

    ContentView()
}
