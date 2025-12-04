//
//  Layout.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct Layout: Identifiable, Codable {
    let id: String
    var name: String
    var imageSizeType: ImageSizeType
    var imagePosition: ImagePosition
}

enum ImageSizeType: Int, Codable, CaseIterable {
    case small = 0
    case medium = 1
    case large = 2
    case fullPage = 3
}

enum ImagePosition: Int, Codable, CaseIterable {
    case top = 0
    case center = 1
    case bottom = 2
    case left = 3
    case right = 4
}
