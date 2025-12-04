//
//  Category.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct BookCategory: Identifiable, Codable, Equatable, Hashable {
    let id: String
    var name: String
    var imageUrl: String
}

extension BookCategory {
    static let mock = BookCategory(
        id: UUID().uuidString,
        name: "Children",
        imageUrl: ""
    )
}
