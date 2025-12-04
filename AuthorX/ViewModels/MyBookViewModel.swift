//
//  MyBookViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation

enum MyBooksState {
    case idle
    case loading
    case loaded
    case creatingBook
    case failed(String)
}

@MainActor
final class MyBooksViewModel: ObservableObject {

    // MARK: - Dependencies
    private let apiService: APIServiceProtocol

    // MARK: - Published State

    @Published var myBooks: [BookDetail] = []
    @Published var remainingBooks: Int = 0
    @Published var userProfile: Profile?

    @Published var state: MyBooksState = .idle
    @Published var isCreateBookPresented: Bool = false

    // MARK: - Init

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    // MARK: - Load Dashboard

    func loadDashboard() {
        state = .loading

        Task {
            do {
                let books = try await apiService.loadMyBooks()

                // Ideally profile should be cached globally,
                // but for now let's assume APIService tracks it.
                let profile = try await apiService.restorePurchase()

                self.myBooks = books
                self.userProfile = profile
                self.remainingBooks = profile.remainingBooks

                self.state = .loaded
            } catch {
                self.state = .failed(error.localizedDescription)
            }
        }
    }

    // MARK: - Create New Book

    func startCreateNewBook() {
        guard remainingBooks > 0 else {
            state = .failed("You have no remaining book credits.")
            return
        }

        isCreateBookPresented = true
    }

    func dismissCreateBook() {
        isCreateBookPresented = false
    }

    // MARK: - After Book Created

    func bookCreated(_ book: BookDetail) {
        state = .creatingBook

        Task {
            do {
                let savedBook = try await apiService.saveBookToAccount(book)

                myBooks.append(savedBook)

                // Update remaining books
                let profile = try await apiService.restorePurchase()
                remainingBooks = profile.remainingBooks
                userProfile = profile

                state = .loaded

            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }
}
