//
//  LoginByEmailView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

struct LoginByEmailView: View {

    @ObservedObject var viewModel: LoginByEmailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Title
            Text("Login by Email")
                .font(.system(size: 22, weight: .bold))

            Text("Please enter your email address")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            // Text field
            TextField("Email", text: $viewModel.email)
                .padding()
                .frame(height: 52)
                .background(Color(white: 0.95))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

            // Submit button (gray like mock)
            Button(action: { viewModel.submitEmail() }) {
                Text("SUBMIT")
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color(white: 0.9))
                    .cornerRadius(12)
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium))
            }
        }
    }
}

