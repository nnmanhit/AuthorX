//
//  LoginByEmailViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

@MainActor
class LoginByEmailViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    let api: APIServiceProtocol
    let onOTPRequested: (String) -> Void

    init(api: APIServiceProtocol, onOTPRequested: @escaping (String) -> Void) {
        self.api = api
        self.onOTPRequested = onOTPRequested
    }

    func submitEmail() {
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email"
            return
        }

        Task {
            isLoading = true
            do {
                try await api.loginWithEmail(email)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.onOTPRequested(self.email)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
