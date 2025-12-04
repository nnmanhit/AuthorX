//
//  ChapterDetailViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

@MainActor
final class ChapterDetailViewModel: ObservableObject {

    private let llmService: LLMServiceProtocol

    @Published var content: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let title: String
    let chapterTitle: String
    let contentLength: Int

    init(
        title: String,
        chapterTitle: String,
        contentLength: Int,
        llmService: LLMServiceProtocol
    ) {
        self.title = title
        self.chapterTitle = chapterTitle
        self.contentLength = contentLength
        self.llmService = llmService
    }

    func generateContent() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let text = try await llmService.generateChapterContent(
                    title: title,
                    chapter: chapterTitle,
                    lengthOfContent: contentLength
                )

                self.content = text
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func reGenerateContent() {
        generateContent()
    }
}
