//
//  MockAPIService.swift
//  AuthorX
//
//  Created by Manh Nguyen on 10/01/25.
//

import Foundation
import UIKit

final class MockAPIService: APIServiceProtocol {
    
    // MARK: - In-memory state
    
    private var currentProfile: Profile?
    private var myBooks: [BookDetail] = []
    private var pendingEmail: String?
    private var activePlan: PurchasePlan?
    
    // for demo
    private let validOTP = "123456"
    
    // MARK: - Home
    
    func loadNewBooks() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3s
        return SampleData.newBooks
    }
    
    func loadTopAuthorBooks() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return SampleData.topAuthorBooks
    }
    
    // MARK: - Auth
    
    func loginWithEmail(_ email: String) async throws {
        try await Task.sleep(nanoseconds: 400_000_000)
        // pretend backend sent OTP to email
        pendingEmail = email
    }
    
    func verifyOTP(_ otp: String) async throws -> Profile {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        guard otp == validOTP, let email = pendingEmail else {
            throw APIServiceError.invalidOTP
        }
        
        // If we already have a profile, return it
        if let profile = currentProfile {
            return profile
        }
        
        // Else create a default "Trial" profile
        let profile = Profile(
            id: UUID().uuidString,
            name: email.components(separatedBy: "@").first ?? "User",
            phoneNumber: "",
            email: email,
            dateOfBirth: "",
            accountType: "Trial",
            remainingBooks: 5,
            myBooks: [],
            profileAvatarUrl: ""
        )
        
        currentProfile = profile
        pendingEmail = nil
        return profile
    }
    
    // MARK: - Profile / Plans
    
    func createProfile(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        dateOfBirth: String
    ) async throws -> Profile {
        try await Task.sleep(nanoseconds: 400_000_000)
        
        let profile = Profile(
            id: UUID().uuidString,
            name: "\(firstName) \(lastName)",
            phoneNumber: phoneNumber,
            email: email,
            dateOfBirth: dateOfBirth,
            accountType: activePlan?.name ?? "Trial",
            remainingBooks: activePlan?.maxBooks ?? 5,
            myBooks: myBooks,
            profileAvatarUrl: ""
        )
        
        currentProfile = profile
        return profile
    }
    
    func loadPurchasePlans() async throws -> [PurchasePlan] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return SampleData.plans
    }
    
    func purchasePlan(_ planId: String) async throws -> Profile {
        try await Task.sleep(nanoseconds: 600_000_000)
        
        guard var profile = currentProfile else {
            throw APIServiceError.notLoggedIn
        }
        
        guard let plan = SampleData.plans.first(where: { $0.id == planId }) else {
            throw APIServiceError.purchaseFailed
        }
        
        activePlan = plan
        profile.accountType = plan.name
        profile.remainingBooks = plan.maxBooks
        currentProfile = profile
        return profile
    }
    
    func restorePurchase() async throws -> Profile {
        try await Task.sleep(nanoseconds: 400_000_000)
        // In a real implementation you'd query StoreKit.
        // Here we just return current profile or create a trial one.
        if let profile = currentProfile {
            return profile
        }
        throw APIServiceError.notLoggedIn
    }
    
    // MARK: - Books
    
    func loadMyBooks() async throws -> [BookDetail] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return myBooks
    }
    
    func saveBookToAccount(_ book: BookDetail) async throws -> BookDetail {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        guard var profile = currentProfile else {
            throw APIServiceError.notLoggedIn
        }
        
        // Decrease remainingBooks if > 0
        if profile.remainingBooks > 0 {
            profile.remainingBooks -= 1
        }
        
        currentProfile = profile
        
        myBooks.append(book)
        return book
    }
    
    // MARK: - Meta
    
    func loadCategories() async throws -> [BookCategory] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return SampleData.categories
    }
    
    func loadImageStyles() async throws -> [UIImage] {
        try await Task.sleep(nanoseconds: 200_000_000)
        // For now just return some placeholder images.
        // In real app this might be URLs or style descriptors.
        return SampleData.imageStylePlaceholders
    }
    
    func updateEpubUrl(bookId: String, epubUrl: String) -> BookDetail? {
        var book = self.myBooks.filter({ $0.book.id == bookId }).first
        book?.epubUrl = epubUrl
        return book
    }
    
}
