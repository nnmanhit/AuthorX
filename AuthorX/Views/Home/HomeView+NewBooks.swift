//
//  HomeView+NewBooks.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

extension HomeView {

    var newBooksSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("New books")
                .font(.title)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {

                    ForEach(viewModel.newBooks, id: \.id) { book in
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
