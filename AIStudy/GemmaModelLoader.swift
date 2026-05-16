//
//  GemmaModelLoader.swift
//  AIStudy
//
//  Created by Anmol Varshney on 16/05/26.
//


import Foundation
import TensorFlowLite

final class GemmaService {

    // MARK: - Properties

    private var interpreter: Interpreter?

    // MARK: - Init

    init() {

        loadModel()
    }

    // MARK: - Load Model

    private func loadModel() {

        guard let modelPath = Bundle.main.path(
            forResource: "gemma-2b-it-gpu-int4",
            ofType: "tflite"
        ) else {

            print("❌ Model not found")
            return
        }

        do {

            var options = Interpreter.Options()

            options.threadCount = 4

            interpreter = try Interpreter(
                modelPath: modelPath,
                options: options
            )

            try interpreter?.allocateTensors()

            print("✅ Gemma loaded successfully")

        } catch {

            print(error)
        }
    }

    // MARK: - Generate Response

    func generateResponse(
        from prompt: String
    ) async -> String {

        guard let interpreter else {

            return "❌ Interpreter missing"
        }

        do {

            // MARK: - Allocate

            try interpreter.allocateTensors()

            // MARK: - Input Count

            let inputTensorCount =
                interpreter.inputTensorCount

            print("INPUT TENSOR COUNT:")
            print(inputTensorCount)

            // MARK: - Output Count

            let outputTensorCount =
                interpreter.outputTensorCount

            print("OUTPUT TENSOR COUNT:")
            print(outputTensorCount)

            // MARK: - Print Inputs

            for index in 0..<inputTensorCount {

                let tensor = try interpreter.input(
                    at: index
                )

                print("INPUT \(index)")
                print("Name:", tensor.name)
                print("Shape:", tensor.shape)
                print("Type:", tensor.dataType)
            }

            // MARK: - Print Outputs

            for index in 0..<outputTensorCount {

                let tensor = try interpreter.output(
                    at: index
                )

                print("OUTPUT \(index)")
                print("Name:", tensor.name)
                print("Shape:", tensor.shape)
                print("Type:", tensor.dataType)
            }

            return """
    ✅ Model inspection complete.
    Check Xcode console.
    """

        } catch {

            print(error)

            return """
    ❌ Debug Failed

    \(error.localizedDescription)
    """
        }
    }
}

// MARK: - Tokenizer

extension GemmaService {

    func tokenize(
        _ text: String
    ) -> [Int32] {

        // VERY SIMPLE TOKENIZER
        // Hackathon MVP only

        let scalars = text.unicodeScalars.map {

            Int32($0.value % 255)
        }

        return scalars
    }

    func decodeToken(
        _ token: Int
    ) -> String {

        // SIMPLE TOKEN DECODER
        // Placeholder for actual tokenizer

        let responses = [

            "This topic explains important concepts clearly.",

            "The uploaded study material discusses educational fundamentals.",

            "Key concepts include definitions, processes, and examples.",

            "This chapter is important for exams and revision.",

            "Focus on understanding the core principles."
        ]

        return responses[
            token % responses.count
        ]
    }
}

// MARK: - Utilities

extension GemmaService {

    func argmax(
        _ array: [Float32]
    ) -> Int {

        guard let maxValue = array.max(),
              let index = array.firstIndex(
                of: maxValue
              ) else {

            return 0
        }

        return index
    }
}

// MARK: - Data Extension

extension Data {

    func toArray<T>(
        type: T.Type
    ) -> [T] {

        withUnsafeBytes {

            Array(
                UnsafeBufferPointer<T>(
                    start: $0.baseAddress?
                        .assumingMemoryBound(
                            to: T.self
                        ),
                    count: count / MemoryLayout<T>.stride
                )
            )
        }
    }
}
