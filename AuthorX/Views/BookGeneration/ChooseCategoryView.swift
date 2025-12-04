//
//  ChooseCategoryView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/29/25.
//

import SwiftUI

struct ChooseCategoryView: View {

    @ObservedObject var viewModel: ChooseCategoryViewModel
    let onNext: (BookCategory) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Title
                    Text("Choose Category")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 20)

                    // MARK: Categories Grid
                    LazyVGrid(columns: columns, spacing: 28) {
                        ForEach(viewModel.categories, id: \.id) { category in
                            CategoryItem(
                                category: category,
                                isSelected: viewModel.selectedCategory?.id == category.id
                            )
                            .onTapGesture {
                                viewModel.selectCategory(category)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
            }

            // MARK: Next Button
            Button(action: {
                if let category = viewModel.selectedCategory {
                    onNext(category)
                }
            }) {
                Text("NEXT")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedCategory == nil ? Color.gray : Color.black)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .disabled(viewModel.selectedCategory == nil)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                .padding(.horizontal, 10)
        )
        .onAppear {
            if viewModel.categories.isEmpty {
                viewModel.loadCategories()
            }
        }
    }
}

struct CategoryItem: View {
    let category: BookCategory
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {

            ZStack {
                Circle()
                    .stroke(isSelected ? Color.blue : Color.blue.opacity(0.7), lineWidth: isSelected ? 3 : 2)
                    .frame(width: 95, height: 95)

                if let url = URL(string: category.imageUrl) {
                    AsyncImage(url: url) { img in
                        img.resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.black)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "questionmark")
                        .font(.system(size: 32))
                }
            }

            Text(category.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}
