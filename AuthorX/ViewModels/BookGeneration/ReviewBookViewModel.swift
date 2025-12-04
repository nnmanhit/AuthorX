//
//  ReviewBookViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import PDFKit

@MainActor
final class ReviewBookViewModel: ObservableObject {

    private let exportService: BookExportServiceProtocol

    @Published var pdfURL: URL?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let bookDetail: BookDetail

    init(bookDetail: BookDetail,
         exportService: BookExportServiceProtocol) {
        self.bookDetail = bookDetail
        self.exportService = exportService
    }

    // Step 1: Generate preview PDF
    func generatePreviewPDF() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let url = try await exportService.generatePDF(
                    bookDetail: bookDetail
                )

                self.pdfURL = url
                self.isLoading = false

            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    // Step 2: Continue
    func next(processVM: ProcessBookViewModel) {
        processVM.startProcessing(bookDetail: bookDetail)
    }
}
