//
//  LoginOverlayView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

struct LoginView: View {

    let onEmailTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Title
            Text("Login")
                .font(.system(size: 22, weight: .bold))

            // Buttons
            VStack(spacing: 16) {
                LoginButton(title: "Email", action: onEmailTap)
                LoginButton(title: "Apple", action: {})
                LoginButton(title: "Google", action: {})
                LoginButton(title: "Facebook", action: {})
            }
        }
    }
}

struct LoginButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.blue)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(Color(white: 0.95))
                .cornerRadius(12)
        }
    }
}
