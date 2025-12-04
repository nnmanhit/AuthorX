//
//  LLMServiceProtocol.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation
import UIKit

protocol LLMServiceProtocol {
    func generateTitle(category: String, numberOfTitles: Int) async throws -> [String]
    func generateCoverImage(title: String, imageStyle: String) async throws -> UIImage
    func generateChapters(title: String, numberOfChapters: Int) async throws -> [String]
    func generateChapterContent(title: String, chapter: String, lengthOfContent: Int) async throws -> String
    func generateChapterImage(title: String, chapter: String, chapterContent: String, imageStyle: String) async throws -> UIImage
}
