//
//  CategorySelectionViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

enum BookGenerationState {
    case idle
    case loadingCategories
    case generatingTitles
    case titlesReady([String])
    case generatingChapters
    case chaptersReady([String])
    case generatingContent
    case generatingImages
    case processing
    case completed(BookDetail)
    case failed(String)
}

@MainActor
final class ChooseCategoryViewModel: ObservableObject {

    private let api: APIServiceProtocol
    
    @Published var categories: [BookCategory] = []
    @Published var selectedCategory: BookCategory?
    @Published var state: BookGenerationState = .idle

    init(api: APIServiceProtocol) {
        self.api = api
    }

    func loadCategories() {
        state = .loadingCategories

        Task {
            do {
                let categories = try await api.loadCategories()
                self.categories = categories
                self.state = .idle
            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    func selectCategory(_ category: BookCategory) {
        selectedCategory = category
    }
}
