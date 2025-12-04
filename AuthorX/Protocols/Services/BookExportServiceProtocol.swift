//
//  BookExportServiceProtocol.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import UIKit

protocol BookExportServiceProtocol {
    func generatePDF(bookDetail: BookDetail) async throws -> URL
    func generateEPUB(bookDetail: BookDetail) async throws -> URL
}

import Foundation

extension FileManager {
    static var exportDirectory: URL {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("GeneratedBooks", isDirectory: true)

        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }

        return dir
    }
}

