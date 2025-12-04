//
//  SplashViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 10/05/25.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    
    @Published var isReady: Bool = false
    
    func start() async {
        
        try? await Task.sleep(nanoseconds: 1_200_000_000)
        
        self.isReady = true
    }
}
