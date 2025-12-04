//
//  HomeView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {

                VStack(spacing: 0) {

                    headerSection

                    searchSection

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 28) {

                            newBooksSection
                            topAuthorBooksSection
                        }
                        .padding(.top, 8)
                    }

                    bottomBar
                }

                // ✅ Login Overlay
                if viewModel.showLoginSheet {
                    ZStack {
                        
                        // Dim background
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                viewModel.closeLogin()
                            }
                        
                        VStack {
                            Spacer()
                            VStack {
                                loginScreens
                            }
                            .padding()
                            .background(.white)
                        }
                    }
                    
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadHomeData()
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                    case .chooseCategory:
                        ChooseCategoryView(
                            viewModel: ChooseCategoryViewModel(api: viewModel.api),
                            onNext: { category in
                                viewModel.goToEnterBookDetail(category: category)
                            })
                    case .enterBookDetail(let category):
                        EnterBookDetailView(
                            viewModel: EnterBookDetailViewModel(apiService: viewModel.api, llmService: viewModel.llm, category: category, onNext: { bookDraft in
                                viewModel.goToGenerateChapters(bookDraft: bookDraft)
                            }))
                    case .generateChapter(let bookDraft):
                        GenerateChaptersView()

                }
            }
        }
    }
    
    @ViewBuilder
        private var loginScreens: some View {
            switch viewModel.loginStep {
            case .methodSelection:
                LoginView {
                    viewModel.goToEmailLogin()
                }
            case .email:
                LoginByEmailView(
                    viewModel: LoginByEmailViewModel(api: viewModel.api, onOTPRequested: { email in
                        viewModel.goToOTP(email: email)
                    })
                )
            case .otp(let email):
                LoginOTPView(
                    viewModel: LoginOTPViewModel(
                        api: viewModel.api,
                        onLoginSuccess: {
                            viewModel.loginCompleted()
                        }
                    )
                )
            }
        }

        private var content: some View {
            // Your existing HomeView content
            Text("Home Content Here")
        }
}

