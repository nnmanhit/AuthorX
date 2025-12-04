//
//  MockBookExportService.swift
//  AuthorX
//
//  Created by Manh Nguyen on 10/01/25.
//

import Foundation
import UIKit

final class MockBookExportService: BookExportServiceProtocol {

    func generatePDF(bookDetail: BookDetail) async throws -> URL {
        let fileURL = FileManager.exportDirectory
            .appendingPathComponent("mock_\(bookDetail.book.id).pdf")

        let text = "Mock PDF for \(bookDetail.book.title)"
        try text.write(to: fileURL, atomically: true, encoding: .utf8)

        return fileURL
    }

    func generateEPUB(bookDetail: BookDetail) async throws -> URL {
        let fileURL = FileManager.exportDirectory
            .appendingPathComponent("mock_\(bookDetail.book.id).epub")

        let text = "Mock EPUB for \(bookDetail.book.title)"
        try text.write(to: fileURL, atomically: true, encoding: .utf8)

        return fileURL
    }
}
