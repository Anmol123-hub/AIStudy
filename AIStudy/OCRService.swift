//
//  OCRService.swift
//  AIStudy
//
//  Created by Anmol Varshney on 16/05/26.
//


import Vision
import UIKit

final class OCRService {

    func extractText(
        from image: UIImage
    ) async -> String {

        guard let cgImage = image.cgImage else {
            return ""
        }

        let request = VNRecognizeTextRequest()

        let handler = VNImageRequestHandler(
            cgImage: cgImage
        )

        do {

            try handler.perform([request])

            let text = request.results?
                .compactMap {
                    $0.topCandidates(1)
                        .first?.string
                }
                .joined(separator: "\n")

            return text ?? ""

        } catch {

            print(error)
            return ""
        }
    }
}