//
//  ChooseChapterLayoutViewModel.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import Combine

@MainActor
final class ChooseChapterLayoutViewModel: ObservableObject {

    @Published var selectedLayout: Layout?
    @Published var layouts: [Layout]

    let chapterTitle: String

    init(chapterTitle: String, availableLayouts: [Layout]) {
        self.chapterTitle = chapterTitle
        self.layouts = availableLayouts
    }

    func selectLayout(_ layout: Layout) {
        selectedLayout = layout
    }
}
