//
//  MockSampleData.swift
//  AuthorX
//
//  Created by Manh Nguyen on 10/01/25.
//

import UIKit
import Foundation

enum SampleData {
    static let author = Author(
        id: UUID().uuidString,
        name: "LLK",
        phoneNumber: "",
        email: "author@example.com",
        dateOfBirth: "1990-01-01"
    )
    
    static let childrenCategory = BookCategory(
        id: "children",
        name: "Children",
        imageUrl: ""
    )
    
    static let educationCategory = BookCategory(
        id: "education",
        name: "Education",
        imageUrl: ""
    )
    
    static let categories: [BookCategory] = [
        childrenCategory,
        educationCategory,
        BookCategory(id: "business", name: "Business", imageUrl: ""),
        BookCategory(id: "health", name: "Health", imageUrl: "")
    ]
    
    static let newBooks: [Book] = (1...4).map { index in
        Book(
            id: UUID().uuidString,
            title: "New Book \(index)",
            author: author,
            category: childrenCategory,
            numChapters: 10,
            coverImageUrl: ""
        )
    }
    
    static let topAuthorBooks: [Book] = (1...4).map { index in
        Book(
            id: UUID().uuidString,
            title: "Top Author Book \(index)",
            author: author,
            category: educationCategory,
            numChapters: 8,
            coverImageUrl: ""
        )
    }
    
    static let plans: [PurchasePlan] = [
        PurchasePlan(id: "bronze",  name: "Bronze",  price: 19.99,  maxBooks: 5,  description: "You can create 5 books", productId: ""),
        PurchasePlan(id: "silver",  name: "Silver",  price: 34.99,  maxBooks: 10, description: "You can create 10 books", productId: ""),
        PurchasePlan(id: "gold",    name: "Gold",    price: 69.99,  maxBooks: 20, description: "You can create 20 books", productId: ""),
        PurchasePlan(id: "diamond", name: "Diamond", price: 169.99, maxBooks: 50, description: "You can create 50 books", productId: "")
    ]
    
    static let imageStylePlaceholders: [UIImage] = {
        // Use solid-colored 1×1 images or SF Symbols rendered to UIImage
        let size = CGSize(width: 10, height: 10)
        
        func solidColor(_ gray: CGFloat) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            UIColor(white: gray, alpha: 1).setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            return image
        }
        
        return [
            solidColor(0.8),
            solidColor(0.6),
            solidColor(0.4)
        ]
    }()
}
