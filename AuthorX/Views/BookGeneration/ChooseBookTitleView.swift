//
//  ChooseBookTitleView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/29/25.
//

import SwiftUI

struct ChooseBookTitleView: View {
    
    @ObservedObject var viewModel: TitleGenerationViewModel
    let onNext: (String) -> Void
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            Text("Choose a book title")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 16)
            
            List(viewModel.titles, id: \.self) { item in
                Button {
                    viewModel.selectedTitle = item
                    onNext(item)
                } label: {
                    Text(item)
                }
            }
            
            Button(action: {
                
                viewModel.generateTitles(for: 10)
                
            }) {
                Text("RE-GENERATE TITLES")
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.generateTitles(for: 10)
        }
    }
    
    private func titleRow(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.black)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.4), lineWidth: 1)
        )
        .onTapGesture {
        }
    }
}
