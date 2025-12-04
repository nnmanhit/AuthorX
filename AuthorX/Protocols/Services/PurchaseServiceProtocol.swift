//
//  PurchaseService.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import UIKit

protocol PurchaseServiceProtocol {
    func loadProducts() async throws -> [PurchaseProduct]
    func purchase(productId: String) async throws -> PurchaseResult
    func restorePurchases() async throws -> PurchaseResult
}
