//
//  ChaptersViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

@MainActor
final class ChaptersViewModel: ObservableObject {

    private let llmService: LLMServiceProtocol

    @Published var chapters: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let title: String
    let numberOfChapters: Int

    init(
        title: String,
        numberOfChapters: Int,
        llmService: LLMServiceProtocol
    ) {
        self.title = title
        self.numberOfChapters = numberOfChapters
        self.llmService = llmService
    }

    func generateChapters() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await llmService.generateChapters(
                    title: title,
                    numberOfChapters: numberOfChapters
                )

                self.chapters = result
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func reGenerateChapters() {
        generateChapters()
    }
}
