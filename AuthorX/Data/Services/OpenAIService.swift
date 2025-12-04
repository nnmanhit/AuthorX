//
//  OpenAIService.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

import Foundation
import UIKit

final class OpenAIService: LLMServiceProtocol {
    private let apiKey: String
    private let session: URLSession
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func generateTitle(category: String, numberOfTitles: Int) async throws -> [String] {
        let prompt = """
        Generate \(numberOfTitles) creative book titles for category: "\(category)".
        Return ONLY JSON:
        { "titles": ["...", "..."] }
        """

        struct TitleResponse: Decodable { let titles: [String] }
        let result: TitleResponse = try await chatJSON(prompt: prompt)
        return result.titles
    }
    
    func generateCoverImage(title: String, imageStyle: String) async throws -> UIImage {
        let prompt = """
        A professional book cover for:
        Title: "\(title)"
        Style: \(imageStyle)
        Centered layout, no text artifacts.
        """
        let images = try await generateImages(prompt: prompt, count: 1)
        guard let first = images.first else { throw LLMServiceError.imageDataMissing }
        return first
    }
    
    func generateChapters(title: String, numberOfChapters: Int) async throws -> [String] {
        let prompt = """
        Create \(numberOfChapters) chapter titles for the book "\(title)".
        Return ONLY JSON:
        { "chapters": ["...", "..."] }
        """

        struct ChaptersResponse: Decodable { let chapters: [String] }
        let result: ChaptersResponse = try await chatJSON(prompt: prompt)
        return result.chapters
    }
    
    func generateChapterContent(
            title: String,
            chapter: String,
            lengthOfContent: Int
    ) async throws -> String {
        let prompt = """
        Book title: "\(title)"
        Chapter: "\(chapter)"
        Length: roughly \(lengthOfContent) words.
        Write engaging, well-structured content.
        """

        return try await chatText(prompt: prompt)
    }
    
    func generateChapterImage(title: String, chapter: String, chapterContent: String, imageStyle: String) async throws -> UIImage {
        let prompt = """
        Illustration for a book chapter.
        Book: "\(title)"
        Chapter: "\(chapter)"
        Content: "\(chapterContent)"
        Style: \(imageStyle), no text, clean composition.
        """
        let images = try await generateImages(prompt: prompt, count: 1)
        guard let first = images.first else { throw LLMServiceError.imageDataMissing }
        return first
    }
    
    // HELPERS
    private func chatJSON<T: Decodable>(prompt: String) async throws -> T {
        let body: [String: Any] = [
            "model": "gpt-4.1-mini",
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": "You are a professional book generation assistant."],
                ["role": "user", "content": prompt]
            ]
        ]

        let data = try await postJSON(url: "https://api.openai.com/v1/chat/completions", body: body)

        let chat = try JSONDecoder().decode(ChatResponse.self, from: data)
        guard let content = chat.choices.first?.message.content.data(using: .utf8) else {
            throw LLMServiceError.decodingFailed
        }

        return try JSONDecoder().decode(T.self, from: content)
    }

    private func chatText(prompt: String) async throws -> String {
        let body: [String: Any] = [
            "model": "gpt-4.1-mini",
            "messages": [
                ["role": "system", "content": "You are a professional book generation assistant."],
                ["role": "user", "content": prompt]
            ]
        ]

        let data = try await postJSON(url: "https://api.openai.com/v1/chat/completions", body: body)

        

        let chat = try JSONDecoder().decode(ChatResponse.self, from: data)
        guard let text = chat.choices.first?.message.content else {
            throw LLMServiceError.invalidResponse
        }
        return text
    }

    private func generateImages(prompt: String, count: Int) async throws -> [UIImage] {
        let body: [String: Any] = [
            "model": "gpt-image-1",
            "prompt": prompt,
            "n": count,
            "size": "1024x1024"
        ]

        let data = try await postJSON(url: "https://api.openai.com/v1/images/generations", body: body)

        struct ImageResponse: Decodable {
            struct Item: Decodable { let url: String }
            let data: [Item]
        }

        let decoded = try JSONDecoder().decode(ImageResponse.self, from: data)

        var images: [UIImage] = []

        for item in decoded.data {
            guard let url = URL(string: item.url) else { continue }
            let (imgData, _) = try await session.data(from: url)
            if let image = UIImage(data: imgData) {
                images.append(image)
            }
        }

        return images
    }

    private func postJSON(url: String, body: [String: Any]) async throws -> Data {
        guard let url = URL(string: url) else { throw LLMServiceError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw LLMServiceError.invalidResponse
        }
        return data
    }
    
}
