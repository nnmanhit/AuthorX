//
//  Errors.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/25/25.
//

enum LLMServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case imageDataMissing
}

enum APIServiceError: Error {
    case invalidOTP
    case notLoggedIn
    case purchaseFailed
    case unknown
}

enum PurchaseError: Error {
    case noPurchaseFound
    case paymentCancelled
    case unknown
}
