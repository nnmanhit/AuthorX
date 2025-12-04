//
//  Profile.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct Profile: Identifiable, Codable {
    let id: String
    var name: String
    var phoneNumber: String
    var email: String
    var dateOfBirth: String
    var accountType: String
    var remainingBooks: Int
    var myBooks: [BookDetail]
    var profileAvatarUrl: String
}
