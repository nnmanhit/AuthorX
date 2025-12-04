//
//  PurchasePlanViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

enum PurchasePlanState {
    case idle
    case loading
    case purchasing
    case restoring
    case success(Profile)
    case failed(String)
}

@MainActor
final class PurchasePlanViewModel: ObservableObject {

    // MARK: - Dependencies
    
    private let apiService: APIServiceProtocol
    private let purchaseService: PurchaseServiceProtocol

    // MARK: - Published
    
    @Published var plans: [PurchasePlanViewData] = []
    @Published var selectedPlan: PurchasePlanViewData?
    @Published var state: PurchasePlanState = .idle
    
    @Published var updatedProfile: Profile?

    // MARK: - Init
    
    init(
        apiService: APIServiceProtocol,
        purchaseService: PurchaseServiceProtocol
    ) {
        self.apiService = apiService
        self.purchaseService = purchaseService
    }

    // MARK: - Load & Merge
    
    func loadPlans() {
        state = .loading

        Task {
            do {
                async let backendPlans = apiService.loadPurchasePlans()
                async let storeProducts = purchaseService.loadProducts()

                let (plans, products) = try await (backendPlans, storeProducts)

                let merged = mergePlans(plans: plans, products: products)

                self.plans = merged
                self.selectedPlan = merged.first
                self.state = .idle

            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    // MARK: - User Selection
    
    func selectPlan(_ plan: PurchasePlanViewData) {
        selectedPlan = plan
    }

    // MARK: - Purchase Flow
    
    func purchaseSelectedPlan() {
        guard let selected = selectedPlan else {
            state = .failed("Please select a plan")
            return
        }

        state = .purchasing

        Task {
            do {
                // Step 1: StoreKit purchase
                let result = try await purchaseService.purchase(productId: selected.productId)

                // Step 2: Notify backend
                let profile = try await apiService.purchasePlan(selected.plan.id)

                self.updatedProfile = profile
                self.state = .success(profile)

            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    // MARK: - Restore Flow
    
    func restorePurchase() {
        state = .restoring

        Task {
            do {
                let result = try await purchaseService.restorePurchases()
                
                // Tell backend
                let planId = mapProductToPlanId(result.productId)
                let profile = try await apiService.purchasePlan(planId)

                self.updatedProfile = profile
                self.state = .success(profile)

            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    // MARK: - Mapping
    
    private func mergePlans(
        plans: [PurchasePlan],
        products: [PurchaseProduct]
    ) -> [PurchasePlanViewData] {

        plans.compactMap { plan in
            guard let product = products.first(where: { $0.id == plan.productId }) else {
                return nil
            }

            return PurchasePlanViewData(
                id: plan.id,
                name: plan.name,
                description: plan.description,
                maxBooks: plan.maxBooks,
                productId: product.id,
                price: product.price,
                rawPrice: product.rawPrice,
                plan: plan,
                product: product
            )
        }
    }

    private func mapProductToPlanId(_ productId: String) -> String {
        plans.first(where: { $0.productId == productId })?.id ?? "bronze"
    }
}
