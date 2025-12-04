//
//  LoginOTPViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

@MainActor
class LoginOTPViewModel: ObservableObject {

    @Published var code: [String] = ["", "", "", "", "", ""]
    @Published var isLoading = false
    @Published var errorMessage: String?

    let api: APIServiceProtocol
    let onLoginSuccess: () -> Void

    init(api: APIServiceProtocol, onLoginSuccess: @escaping () -> Void) {
        self.api = api
        self.onLoginSuccess = onLoginSuccess
    }

    var otp: String {
        code.joined()
    }

    func submitOTP() {
        guard otp.count == 6 else {
            errorMessage = "Invalid OTP"
            return
        }

        Task {
            isLoading = true
            do {
                let profile = try await api.verifyOTP(otp)
                Session.shared.setProfile(profile)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    // Save profile to some ProfileStore if needed
                    self.onLoginSuccess()
                }

            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Incorrect OTP"
                }
            }
        }
    }
}
