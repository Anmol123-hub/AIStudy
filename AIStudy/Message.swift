//
//  Message.swift
//  AIStudy
//
//  Created by Anmol Varshney on 16/05/26.
//


import UIKit

struct Message: Identifiable {

    let id = UUID()

    let text: String

    let isUser: Bool

    var image: UIImage? = nil
}