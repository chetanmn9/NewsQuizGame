//
//  ImageView.swift
//  QuizGame


import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: ImageViewModel

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 250, maxHeight: 250)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())

            case .success(let image):
                GeometryReader { geometry in
                    let width = geometry.size.width * 0.98

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: 210)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .position(x: geometry.size.width / 2, y: 125) // Center horizontally, keep vertical height consistent
                }
                .frame(height: 250) // Limit GeometryReader height to avoid full-screen layout


            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: 250, maxHeight: 250)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)
                    .clipped() // Ensure no overflow
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )

            case .unknown:
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: 250, maxHeight: 250)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)
                    .clipped() // Ensure no overflow
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )

            }
        }
        .onAppear {
            viewModel.loadImage()
        }
    }
}

