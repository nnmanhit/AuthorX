//
//  ProcessBookViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

enum ProcessBookState {
    case idle
    case processing(progress: Double, message: String)
    case completed(BookDetail)
    case canceled
    case failed(String)
}

@MainActor
final class ProcessBookViewModel: ObservableObject {

    private let exportService: BookExportServiceProtocol
    private let apiService: APIServiceProtocol

    @Published var state: ProcessBookState = .idle

    init(exportService: BookExportServiceProtocol,
         apiService: APIServiceProtocol) {
        self.exportService = exportService
        self.apiService = apiService
    }

    func startProcessing(bookDetail: BookDetail) {
        state = .processing(progress: 0.1, message: "Saving book...")

        Task {
            do {
                // Step 1: Save to backend
                let savedBook = try await apiService.saveBookToAccount(bookDetail)

                self.state = .processing(progress: 0.4, message: "Generating EPUB...")

                // Step 2: Generate EPUB
                let epubURL = try await exportService.generateEPUB(
                    bookDetail: savedBook
                )

                var updatedBook = savedBook
                updatedBook.epubUrl = epubURL.absoluteString

                self.state = .processing(progress: 0.8, message: "Finalizing...")

                // Step 3: Update backend again
                let finalBook = try await apiService.updateEpubUrl(
                    bookId: updatedBook.book.id,
                    epubUrl: epubURL.absoluteString
                )

                if let finalBook = finalBook {
                    self.state = .completed(finalBook)
                } else {
                    self.state = .failed("Not found")
                }

            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    func cancel() {
        state = .canceled
    }
}
