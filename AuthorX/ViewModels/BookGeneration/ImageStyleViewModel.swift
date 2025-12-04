//
//  ImageStyleViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine
import UIKit

@MainActor
final class ImageStyleViewModel: ObservableObject {

    private let apiService: APIServiceProtocol

    @Published var imageStyles: [UIImage] = []
    @Published var selectedStyleIndex: Int?
    @Published var state: BookGenerationState = .idle

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func loadImageStyles() {
        Task {
            do {
                let styles = try await apiService.loadImageStyles()
                self.imageStyles = styles
            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    func selectStyle(at index: Int) {
        selectedStyleIndex = index
    }
}
