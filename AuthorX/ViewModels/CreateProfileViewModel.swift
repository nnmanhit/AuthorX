//
//  CreateProfileViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

enum CreateProfileState {
    case idle
    case submitting
    case success(Profile)
    case failed(String)
}

import Foundation

@MainActor
final class CreateProfileViewModel: ObservableObject {

    // MARK: - Dependencies
    private let apiService: APIServiceProtocol

    // MARK: - Inputs
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var dateOfBirth: String = ""
    
    // MARK: - State
    
    @Published var state: CreateProfileState = .idle
    @Published var createdProfile: Profile?
    
    // MARK: - Init
    
    init(apiService: APIServiceProtocol, email: String? = nil) {
        self.apiService = apiService
        self.email = email ?? ""
    }
    
    // MARK: - Logic

    func submitProfile() {
        guard validateInputs() else {
            state = .failed("Please fill in all fields.")
            return
        }
        
        state = .submitting
        
        Task {
            do {
                let profile = try await apiService.createProfile(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber,
                    dateOfBirth: dateOfBirth
                )
                
                self.createdProfile = profile
                self.state = .success(profile)
                
            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }
}

// MARK: - Validation

extension CreateProfileViewModel {
    
    private func validateInputs() -> Bool {
        return !firstName.isEmpty &&
               !lastName.isEmpty &&
               !email.isEmpty &&
               !phoneNumber.isEmpty &&
               !dateOfBirth.isEmpty
    }
    
    func reset() {
        firstName = ""
        lastName = ""
        phoneNumber = ""
        dateOfBirth = ""
        state = .idle
    }
}
