//
//  HomeViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/25/25.
//

import Foundation
import Combine
import SwiftUI

enum LoginStep {
    case methodSelection
    case email
    case otp(email: String)
}

enum HomeRoute: Hashable {
    case chooseCategory
    case enterBookDetail(category: BookCategory)
    case generateChapter(bookDraft: BookDraft)
}

enum HomeViewState {
    case iddle
    case loading
    case error
    case completeLoadingNew
}

@MainActor
final class HomeViewModel: ObservableObject {

    let api: APIServiceProtocol
    let llm: LLMServiceProtocol

    @Published var navigationPath = NavigationPath()
    
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showLoginSheet = false
    @Published var showLoginByEmail = false
    @Published var showOTPView = false
    @Published var loginStep: LoginStep = .methodSelection

    @Published var newBooks: [Book] = []
    @Published var topAuthorBooks: [Book] = []

    init(api: APIServiceProtocol, llm: LLMServiceProtocol) {
        self.api = api
        self.llm = llm
    }

    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        default:      return "Good Evening,"
        }
    }

    var userNameText: String {
        Session.shared.getProfile()?.name ?? "Guest"
    }

    // MARK: - Lifecycle

    func onAppear() {
        Task { await loadHomeData() }
    }

    // MARK: - Actions used by HomeView

    func openBook(_ book: Book) {
        print("Navigate to Book Detail: \(book.title)")
        // later -> coordinator.push(BookDetailView)
    }

    func createNewBook() {
        if Session.shared.getProfile() == nil {
            showLoginSheet = true
            loginStep = .methodSelection
        } else {
            print("Navigate to ChooseCategoryView")
            navigationPath.append(HomeRoute.chooseCategory)
        }
    }

    func openMyAccount() {
        if Session.shared.getProfile() == nil {
            showLoginSheet = true
            loginStep = .methodSelection
        } else {
            print("Navigate to ProfileView")
        }
    }
    
    func goToEmailLogin() {
        loginStep = .email
    }
    
    func goToOTP(email: String) {
        loginStep = .otp(email: email)
    }
    
    func loginCompleted() {
        showLoginSheet = false
    }
    
    func closeLogin() {
        showLoginSheet = false
    }
    
    func goToEnterBookDetail(category: BookCategory) {
        navigationPath.append(HomeRoute.enterBookDetail(category: category))
    }
    
    func goToGenerateChapters(bookDraft: BookDraft) {
        navigationPath.append(HomeRoute.generateChapter(bookDraft: bookDraft))
    }

    // MARK: - Data Loading
    func loadHomeData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let newBooks = api.loadNewBooks()
            async let topBooks = api.loadTopAuthorBooks()

            let (new, top) = try await (newBooks, topBooks)

            self.newBooks = new
            self.topAuthorBooks = top
            self.isLoading = false

        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}

