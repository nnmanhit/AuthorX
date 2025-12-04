//
//  GeminiService.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation
import UIKit

final class GeminiService: LLMServiceProtocol {
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func generateTitle(category: String, numberOfTitles: Int) async throws -> [String] {
        let prompt = "Generate \(numberOfTitles) book titles for category '\(category)' and return JSON {\"titles\": [ ... ]}"
        return try await generateJSON(prompt: prompt, key: "titles")
    }

    func generateChapters(title: String, numberOfChapters: Int) async throws -> [String] {
        let prompt = "Generate \(numberOfChapters) chapter names for book '\(title)' and return JSON {\"chapters\": [ ... ]}"
        return try await generateJSON(prompt: prompt, key: "chapters")
    }

    func generateChapterContent(title: String, chapter: String, lengthOfContent: Int) async throws -> String {
        let prompt = """
        Write a chapter for:
        Book: \(title)
        Chapter: \(chapter)
        Length: \(lengthOfContent) words
        """
        return try await generateText(prompt: prompt)
    }

    func generateCoverImage(title: String, imageStyle: String) async throws -> UIImage {
        let prompt = "Book cover illustration for '\(title)' in style: \(imageStyle)"
        return try await generateImage(prompt: prompt)
    }

    func generateChapterImage(title: String, chapter: String, chapterContent: String, imageStyle: String) async throws -> UIImage {
        let prompt = "Chapter illustration for '\(title)' chapter '\(chapter)' with content '\(chapterContent)' in style: \(imageStyle)"
        return try await generateImage(prompt: prompt)
    }

    // ---------------- Helpers ----------------

    private func generateText(prompt: String) async throws -> String {
        let url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)"

        let body: [String: Any] = [
            "contents": [[
                "parts": [["text": prompt]]
            ]]
        ]

        let data = try await postJSON(url: url, body: body)

        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        guard let text = decoded.candidates.first?.content.parts.first?.text else {
            throw LLMServiceError.invalidResponse
        }

        return text
    }

    private func generateImage(prompt: String) async throws -> UIImage {
        let url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent?key=\(apiKey)"

        let body: [String: Any] = [
            "contents": [[
                "parts": [["text": prompt]]
            ]],
            "generationConfig": [
                "responseModalities": ["IMAGE"]
            ]
        ]

        let data = try await postJSON(url: url, body: body)

        let decoded = try JSONDecoder().decode(GeminiImageResponse.self, from: data)

        for candidate in decoded.candidates {
            for part in candidate.content.parts {
                if let base64 = part.inlineData?.data,
                   let data = Data(base64Encoded: base64),
                   let image = UIImage(data: data) {
                    return image
                }
            }
        }

        throw LLMServiceError.imageDataMissing
    }

    private func generateJSON(prompt: String, key: String) async throws -> [String] {
        let text = try await generateText(prompt: prompt)
        let data = Data(text.utf8)

        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let result = json[key] as? [String] {
            return result
        }

        throw LLMServiceError.decodingFailed
    }

    private func postJSON(url: String, body: [String: Any]) async throws -> Data {
        guard let url = URL(string: url) else { throw LLMServiceError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw LLMServiceError.invalidResponse
        }

        return data
    }
}
