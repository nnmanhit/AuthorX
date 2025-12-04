//
//  PurchasePlan.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct PurchasePlan: Identifiable, Codable {
    let id: String           // "bronze", "silver", ...
    let name: String         // "Bronze"
    let price: Double        // 19.99
    let maxBooks: Int        // 5, 10, 20, 50
    let description: String  // "You can create 5 books"
    let productId: String
}
