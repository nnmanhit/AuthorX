//
//  AuthorCardView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

struct AuthorCardView: View {
    let author: Author

    var body: some View {
        VStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    AsyncImage(url: URL(string: author.avatarUrl ?? ""))
                )

            Text(author.name)
                .font(.caption)
        }
        .frame(width: 90)
    }
}
