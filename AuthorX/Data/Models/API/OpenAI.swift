//
//  OpenAI.swift
//  AuthorX
//
//  Created by Manh Nguyen on 09/25/25.
//

struct OpenAIChatResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

struct OpenAIImageResponse: Decodable {
    struct DataItem: Decodable {
        let url: String?
        let b64_json: String?
    }
    let data: [DataItem]
}

struct ChatResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable { let content: String }
        let message: Message
    }
    let choices: [Choice]
}
