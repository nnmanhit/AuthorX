//
//  TitleGenerationViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

@MainActor
final class TitleGenerationViewModel: ObservableObject {

    private let llmService: LLMServiceProtocol
    private let category : BookCategory

    @Published var titles: [String] = []
    @Published var selectedTitle: String?
    @Published var state: BookGenerationState = .idle

    init(llmService: LLMServiceProtocol, category: BookCategory) {
        self.llmService = llmService
        self.category = category
    }

    func generateTitles(for count: Int = 5) {
        state = .generatingTitles

        Task {
            do {
                let result = try await llmService.generateTitle(
                    category: category.name,
                    numberOfTitles: count
                )

                self.titles = result
                self.state = .titlesReady(result)

            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    func selectTitle(_ title: String) {
        selectedTitle = title
    }
}
