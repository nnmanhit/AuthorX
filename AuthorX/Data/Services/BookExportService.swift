//
//  BookExportService.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import PDFKit
import UIKit

enum ExportError: Error {
    case pdfGenerationFailed
    case epubGenerationFailed
}

final class BookExportService: BookExportServiceProtocol {

    private let epubBuilder = EPUBBuilder()
    
    private let pdfRenderer = PDFBookRenderer()

    func generatePDF(bookDetail: BookDetail) async throws -> URL {

        let pdfData = try pdfRenderer.generatePDF(bookDetail: bookDetail)

        let fileURL = FileManager.exportDirectory
            .appendingPathComponent("book_\(bookDetail.book.id).pdf")

        try pdfData.write(to: fileURL)

        return fileURL
    }

    func generateEPUB(bookDetail: BookDetail) async throws -> URL {
        let filename = "book_\(bookDetail.book.id).epub"
        let fileURL = FileManager.exportDirectory.appendingPathComponent(filename)
        
        try await Task.detached(priority: .userInitiated) { [epubBuilder = self.epubBuilder] in
            try epubBuilder.buildEPUB(from: bookDetail, to: fileURL)
        }.value
        
        return fileURL
    }
}
