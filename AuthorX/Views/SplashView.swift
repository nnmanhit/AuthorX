//
//  SplashView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject private var viewModel = SplashViewModel()
    @State private var animateLogo = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [Color.black, Color.gray],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Image("AppLogo") // <-- your logo asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateLogo ? 1.0 : 0.7)
                    .opacity(animateLogo ? 1 : 0)
                    .animation(.easeOut(duration: 1.0), value: animateLogo)
                
                Text("BookForge")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(animateLogo ? 1 : 0)
                    .animation(.easeIn(duration: 1.3), value: animateLogo)
                
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: .white)
                    )
                    .scaleEffect(1.4)
                    .padding(.top, 20)
            }
        }
        .task {
            animateLogo = true
            await viewModel.start()
        }
        .fullScreenCover(isPresented: $viewModel.isReady) {
            let homeViewModel = HomeViewModel(api: MockAPIService(), llm: OpenAIService(apiKey: "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"))
            HomeView(viewModel: homeViewModel)
        }
    }
}
