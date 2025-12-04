//
//  PurchaseProduct.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation
import UIKit

struct PurchaseProduct: Identifiable {
    let id: String
    let displayName: String
    let description: String
    let price: String      // formatted
    let rawPrice: Double
}
