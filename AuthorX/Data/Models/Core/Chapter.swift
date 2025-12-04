//
//  Chapter.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct Chapter: Identifiable, Codable {
    let id: String
    var chapterOrder: Int
    var content: String
    var chapterImageUrl: String
    var chapterLayout: Layout
}
