//
//  EnterBookDetailView.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/29/25.
//

import SwiftUI

struct EnterBookDetailView: View {

    @ObservedObject var viewModel: EnterBookDetailViewModel
    @State private var showChooseTitle = false

    var body: some View {

        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    Text("Book Detail")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // MARK: Title + Arrow
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Title")
                            Spacer()
                            Button(action: {
                                showChooseTitle = true
                            }) {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black)
                            }
                        }

                        TextField("", text: $viewModel.title)
                            .textFieldStyle(UnderlineTextFieldStyle())
                    }

                    labeledInput("Author", text: $viewModel.author)
                    labeledInput("Copyright", text: $viewModel.copyright)
                    labeledInput("Number of chapters", text: $viewModel.numberOfChapters, keyboard: .numberPad)
                    labeledInput("Length of content", text: $viewModel.lengthOfContent, keyboard: .numberPad)

                    // MARK: Image Style
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Image style")

                        HStack(spacing: 20) {

                            imageStyleOption("Style 1")
                            imageStyleOption("Style 2")
                            imageStyleOption("Style 3")
                        }
                    }

                    labeledInput("Signature", text: $viewModel.signature)
                }
                .padding(.horizontal, 24)
            }

            // MARK: NEXT button
            Button(action: {
                viewModel.proceedToNext()
            }) {
                Text("NEXT")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .padding(.top, 20)
        .sheet(isPresented: $showChooseTitle) {
            
            NavigationStack {
                ChooseBookTitleView(
                    viewModel: TitleGenerationViewModel(
                        llmService: viewModel.llmService,
                        category: viewModel.category
                    )
                ) { selectedTitle in
                    viewModel.title = selectedTitle
                    showChooseTitle = false
                }
            }
            
        }
        
    }

    // MARK: Input Helper
    private func labeledInput(_ label: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
            TextField("", text: text)
                .textFieldStyle(UnderlineTextFieldStyle())
                .keyboardType(keyboard)
        }
    }

    // MARK: Image Style Option
    private func imageStyleOption(_ title: String) -> some View {
        let isSelected = viewModel.selectedImageStyle == title

        return Button(action: {
            viewModel.selectedImageStyle = title
        }) {
            VStack {
                Text("Image")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.blue.opacity(0.6), lineWidth: isSelected ? 3 : 2)
            )
        }
    }
}

// MARK: Custom Underline TextField
struct UnderlineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(.vertical, 8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .padding(.top, 28)
                    .foregroundColor(Color.blue)
            )
    }
}
