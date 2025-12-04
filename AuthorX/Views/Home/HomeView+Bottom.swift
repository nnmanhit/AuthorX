//
//  HomeView+Bottom.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/28/25.
//
import SwiftUI

extension HomeView {

    var bottomBar: some View {
        VStack {
            Divider()
            
            HStack {
                
                Spacer()

                VStack {
                    Image(systemName: "house")
                    Text("   Home   ")
                        .font(.caption)
                }

                Spacer()

                Button {
                    viewModel.createNewBook()
                } label: {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                        )
                }
                .offset(y: -40)

                Spacer()

                VStack {
                    Image(systemName: "person")
                    Text("My account")
                        .font(.caption)
                }
                .onTapGesture {
                    viewModel.openMyAccount()
                }

                Spacer()

            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}
