//
//  APIServiceProtocol.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/25/25.
//

import Foundation
import UIKit

protocol APIServiceProtocol {
    // Home
    func loadNewBooks() async throws -> [Book]
    func loadTopAuthorBooks() async throws -> [Book]
    
    // Auth
    func loginWithEmail(_ email: String) async throws           // request OTP
    func verifyOTP(_ otp: String) async throws -> Profile       // confirm & fetch profile
    
    // Profile / Plans
    func createProfile(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        dateOfBirth: String
    ) async throws -> Profile
    
    func loadPurchasePlans() async throws -> [PurchasePlan]
    func purchasePlan(_ planId: String) async throws -> Profile
    func restorePurchase() async throws -> Profile
    
    // Books
    func loadMyBooks() async throws -> [BookDetail]
    func saveBookToAccount(_ book: BookDetail) async throws -> BookDetail
    func updateEpubUrl(bookId: String, epubUrl: String) async throws -> BookDetail?
    
    // Meta
    func loadCategories() async throws -> [BookCategory]
    func loadImageStyles() async throws -> [UIImage]
}
