//
//  PurchasePlanViewData.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation

struct PurchasePlanViewData: Identifiable {
    let id: String                 // planId (bronze, silver…)
    let name: String
    let description: String
    let maxBooks: Int
    
    let productId: String
    let price: String              // From StoreKit
    let rawPrice: Double

    let plan: PurchasePlan
    let product: PurchaseProduct
}
