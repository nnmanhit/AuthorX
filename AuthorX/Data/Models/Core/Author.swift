//
//  Author.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct Author: Identifiable, Codable {
    let id: String
    var name: String
    var phoneNumber: String
    var email: String
    var dateOfBirth: String
    var avatarUrl : String?
}

extension Author {
    static let mock = Author(
        id: UUID().uuidString,
        name: "Manh Nguyen",
        phoneNumber: "",
        email: "manh@example.com",
        dateOfBirth: "1985-01-01",
        avatarUrl: nil
    )
}
