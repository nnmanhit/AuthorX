//
//  BookGenerationViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine
import UIKit

@MainActor
final class GenerateCoverImageViewModel: ObservableObject {

    private let llmService: LLMServiceProtocol

    @Published var coverImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let title: String
    let imageStyle: String

    init(
        title: String,
        imageStyle: String,
        llmService: LLMServiceProtocol
    ) {
        self.title = title
        self.imageStyle = imageStyle
        self.llmService = llmService
    }

    func generateCover() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let image = try await llmService.generateCoverImage(
                    title: title,
                    imageStyle: imageStyle
                )

                self.coverImage = image
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func reGenerateCover() {
        generateCover()
    }
}
