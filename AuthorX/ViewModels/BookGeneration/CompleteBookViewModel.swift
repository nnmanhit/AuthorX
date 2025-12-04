//
//  CompleteBookViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

enum CompleteBookState {
    case idle
    case completed
}

@MainActor
final class CompleteBookViewModel: ObservableObject {

    // MARK: - State
    
    @Published var state: CompleteBookState = .completed
    
    // MARK: - Data
    
    let bookDetail: BookDetail
    
    // MARK: - Init
    
    init(bookDetail: BookDetail) {
        self.bookDetail = bookDetail
    }
    
    // MARK: - Derived UI Display
    
    var title: String {
        bookDetail.book.title
    }
    
    var authorName: String {
        bookDetail.book.author.name
    }
    
    var pdfURL: URL? {
        URL(string: bookDetail.pdfUrl)
    }
    
    var epubURL: URL? {
        URL(string: bookDetail.epubUrl)
    }
    
    var numberOfChapters: Int {
        bookDetail.chapters.count
    }
    
    // MARK: - User Actions
    
    func viewPDF() -> URL? {
        pdfURL
    }
    
    func viewEPUB() -> URL? {
        epubURL
    }
    
    func goToMyBooks() {
        // Navigation handled by Coordinator / Router
        print("Navigate to My Books screen")
    }
    
    func createAnotherBook() {
        // Reset flow back to Category Selection
        print("Restart create book flow")
    }
    
    func shareBook() -> [URL] {
        var urls: [URL] = []
        
        if let pdf = pdfURL {
            urls.append(pdf)
        }
        
        if let epub = epubURL {
            urls.append(epub)
        }
        
        return urls
    }
}

