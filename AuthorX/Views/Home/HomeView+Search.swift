//
//  HomeView+Search.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

extension HomeView {

    var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")

            TextField("Search", text: $viewModel.searchText)
                .autocorrectionDisabled()

        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}
