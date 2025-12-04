//
//  BookDetail.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct BookDetail: Codable {
    var book: Book
    var chapters: [Chapter]
    var signature: String
    var pdfUrl: String
    var epubUrl: String
}
