//
//  MockPurchaseService.swift
//  AuthorX
//
//  Created by Manh Nguyen on 10/01/25.
//

import Foundation

final class MockPurchaseService: PurchaseServiceProtocol {
    
    // Simulated purchased product
    private var lastPurchasedProductId: String?

    func loadProducts() async throws -> [PurchaseProduct] {
        try await Task.sleep(nanoseconds: 400_000_000) // simulate loading delay
        
        return [
            PurchaseProduct(id: "com.thebookplatform.plan.bronze",
                            displayName: "Bronze Plan",
                            description: "Create up to 5 books",
                            price: "$4.99",
                            rawPrice: 4.99),
            
            PurchaseProduct(id: "com.thebookplatform.plan.silver",
                            displayName: "Silver Plan",
                            description: "Create up to 10 books",
                            price: "$8.99",
                            rawPrice: 8.99),
            
            PurchaseProduct(id: "com.thebookplatform.plan.gold",
                            displayName: "Gold Plan",
                            description: "Create up to 20 books",
                            price: "$14.99",
                            rawPrice: 14.99),
            
            PurchaseProduct(id: "com.thebookplatform.plan.diamond",
                            displayName: "Diamond Plan",
                            description: "Create up to 50 books",
                            price: "$29.99",
                            rawPrice: 29.99)
        ]
    }

    func purchase(productId: String) async throws -> PurchaseResult {
        try await Task.sleep(nanoseconds: 800_000_000)
        
        lastPurchasedProductId = productId
        
        return PurchaseResult(
            productId: productId,
            transactionId: UUID().uuidString,
            purchaseDate: Date()
        )
    }

    func restorePurchases() async throws -> PurchaseResult {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        guard let productId = lastPurchasedProductId else {
            throw PurchaseError.noPurchaseFound
        }
        
        return PurchaseResult(
            productId: productId,
            transactionId: UUID().uuidString,
            purchaseDate: Date()
        )
    }
}
