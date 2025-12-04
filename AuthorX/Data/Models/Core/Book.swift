//
//  Book.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct Book: Identifiable, Codable {
    let id: String
    var title: String
    var author: Author
    var category: BookCategory
    var numChapters: Int
    var coverImageUrl: String
}

extension Book {
    static let mock = Book(
        id: UUID().uuidString,
        title: "The Tree That Gives Good Luck",
        author: Author.mock,
        category: BookCategory.mock,
        numChapters: 5,
        coverImageUrl: ""
    )
}
