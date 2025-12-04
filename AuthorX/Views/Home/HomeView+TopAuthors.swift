//
//  HomeView+TopAuthors.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

extension HomeView {

    var topAuthorBooksSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Top Authors")
                .font(.title)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {

                    ForEach(viewModel.topAuthorBooks, id: \.id) { book in
                        BookCardView(book: book)
                            .onTapGesture {
                                viewModel.openBook(book)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
