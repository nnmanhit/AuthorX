//
//  HomeView+Header.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

extension HomeView {

    var headerSection: some View {
        HStack(spacing: 12) {

            Image("logo")
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .border(.gray)

            VStack(alignment: .leading, spacing: 0) {
                Text("Good Morning,")
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text(Session.shared.getProfile()?.name ?? "Manh Nguyen")
                    .font(.title3.bold())
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
