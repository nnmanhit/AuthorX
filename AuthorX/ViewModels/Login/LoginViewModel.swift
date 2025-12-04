//
//  LoginViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

enum LoginFlowState {
    case idle
    case sendingOTP
    case waitingForOTP
    case verifyingOTP
    case loggedIn(Profile)
    case failed(String)
}

@MainActor
final class LoginViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let apiService: APIServiceProtocol
    
    // MARK: - Published State
    @Published var isEmailLoginSelected: Bool = false
    @Published var state: LoginFlowState = .idle
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func loginWithEmailSelected() {
        isEmailLoginSelected = true
    }
    
    func reset() {
        isEmailLoginSelected = false
        state = .idle
    }
}
