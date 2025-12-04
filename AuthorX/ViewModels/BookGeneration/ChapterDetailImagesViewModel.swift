//
//  ChapterDetailImagesViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine
import UIKit

@MainActor
final class ChapterDetailImagesViewModel: ObservableObject {

    private let llmService: LLMServiceProtocol

    @Published var images: [UIImage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let title: String
    let chapterTitle: String
    let chapterContent: String
    let imageStyle: String

    init(
        title: String,
        chapterTitle: String,
        chapterContent: String,
        imageStyle: String,
        llmService: LLMServiceProtocol
    ) {
        self.title = title
        self.chapterTitle = chapterTitle
        self.chapterContent = chapterContent
        self.imageStyle = imageStyle
        self.llmService = llmService
    }

    func generateImages() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let image = try await llmService.generateChapterImage(
                    title: title,
                    chapter: chapterTitle,
                    chapterContent: chapterContent,
                    imageStyle: imageStyle
                )

                self.images = [image]   // you can expand to multiple later
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func reGenerateImages() {
        generateImages()
    }
}
