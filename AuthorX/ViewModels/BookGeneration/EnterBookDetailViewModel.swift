//
//  EnterBookDetailViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/29/25.
//

import SwiftUI

@MainActor
final class EnterBookDetailViewModel: ObservableObject {
    
    // Dependencies
    let apiService: APIServiceProtocol
    let llmService: LLMServiceProtocol
    let category: BookCategory

    // Published fields
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var copyright: String = ""
    @Published var numberOfChapters: String = ""
    @Published var lengthOfContent: String = ""
    @Published var signature: String = ""

    // Selected image style (Small, Medium, Large or any custom styles)
    @Published var selectedImageStyle: String?

    // For routing
    let onNext: (BookDraft) -> Void

    init(
        apiService: APIServiceProtocol,
        llmService: LLMServiceProtocol,
        category: BookCategory,
        onNext: @escaping (BookDraft) -> Void
    ) {
        self.apiService = apiService
        self.llmService = llmService
        self.category = category
        self.onNext = onNext
    }

    func proceedToNext() {
        guard validateInputs() else { return }

        let data = BookDraft(
            title: title,
            authorName: author,
            copyright: copyright,
            numberOfChapters: Int(numberOfChapters) ?? 5,
            lengthOfContent: Int(lengthOfContent) ?? 1000,
            imageStyle: selectedImageStyle ?? "Default",
            signature: signature,
            category: category
        )

        onNext(data)
    }

    private func validateInputs() -> Bool {
        return !title.isEmpty &&
               !author.isEmpty &&
               !copyright.isEmpty &&
               Int(numberOfChapters) != nil &&
               Int(lengthOfContent) != nil &&
               selectedImageStyle != nil
    }
}

struct BookDraft: Hashable, Equatable {
    static func == (lhs: BookDraft, rhs: BookDraft) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String = UUID().uuidString
    var title: String
    var authorName: String
    var copyright: String
    var numberOfChapters: Int
    var lengthOfContent: Int
    var imageStyle: String
    var signature: String
    var category: BookCategory
}
