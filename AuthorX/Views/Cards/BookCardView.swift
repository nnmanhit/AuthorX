//
//  BookCardView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

struct BookCardView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 120, height: 160)
                .overlay(
                    AsyncImage(url: URL(string: book.coverImageUrl))
                )

            Text(book.title)
                .font(.subheadline.bold())

            Text("By \(book.author.name)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 120)
    }
}
