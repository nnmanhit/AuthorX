//
//  Gemini.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

struct GeminiGenerateContentResponse: Decodable {
    struct Candidate: Decodable {
        struct Content: Decodable {
            struct Part: Decodable {
                let text: String?
                let inlineData: InlineData?
                
                struct InlineData: Decodable {
                    let mimeType: String
                    let data: String // base64 image data
                }
            }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}

struct GeminiImageResponse: Decodable {
    struct Candidate: Decodable {
        struct Content: Decodable {
            struct Part: Decodable {
                struct InlineData: Decodable {
                    let data: String
                }
                let inlineData: InlineData?
            }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}

struct GeminiResponse: Decodable {
    struct Candidate: Decodable {
        struct Content: Decodable {
            struct Part: Decodable { let text: String? }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}
