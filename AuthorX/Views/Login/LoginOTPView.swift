//
//  LoginOTPView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

struct LoginOTPView: View {

    @ObservedObject var viewModel: LoginOTPViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Title
            Text("Login by Email")
                .font(.system(size: 22, weight: .bold))

            Text("Please enter your OTP")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            // OTP Input Boxes
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $viewModel.code[index])
                        .frame(width: 46, height: 52)
                        .background(Color(white: 0.95))
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
            }

            // Submit button (gray like mock)
            Button(action: { viewModel.submitOTP() }) {
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

