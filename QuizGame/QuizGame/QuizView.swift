//
//  ContentView.swift
//  QuizGame


import Foundation
import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    headerView
                    progressView
                    quizImageView()
                    contentView()
                }
                .padding(.vertical)
                .animation(.easeInOut(duration: 0.3), value: viewModel.selectedAnswer)
            }
            .navigationTitle("Quiz Game")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }

    private var headerView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("🎯 Guess the Headline")
                    .font(.title)
                    .fontWeight(.bold)

                if let section = viewModel.currentItem?.section {
                    Text(section.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                }

                Text("Can you pick the right headline for this story?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 4)
                        .frame(width: 72, height: 72)
                        .shadow(radius: 3)

                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                        .frame(width: 85, height: 85)

                    VStack(spacing: 0) {
                        Text("SCORE")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .bold()
                        Text("\(viewModel.score)")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }

    private var progressView: some View {
        return AnyView(EmptyView())
    }

    @ViewBuilder
    private func quizImageView() -> some View {
        if let imageVM = viewModel.imageViewModel {
            ImageView(viewModel: imageVM)
                .padding(.horizontal)
                .shadow(radius: 5)
                .transition(.opacity)
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        if let current = viewModel.currentItem {
            if viewModel.selectedAnswer == nil {
                answerOptionsView(for: current)
            } else {
                feedbackView(for: current)
            }
        } else if viewModel.isLoading {
            ProgressView("Loading quiz...")
                .padding(.top, 50)
        } else if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .padding()
        }
    }

    private func answerOptionsView(for current: Item) -> some View {
        VStack(spacing: 16) {
            ForEach(current.headlines.indices, id: \.self) { index in
                let isSelected = viewModel.selectedAnswer == index
                let isCorrect = current.correctAnswerIndex == index

                Button(action: {
                    withAnimation {
                        viewModel.selectAnswer(index)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }) {
                    Text(current.headlines[index])
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(isSelected ? 0.7 : 1.0))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .scaleEffect(isSelected ? 1.02 : 1.0)
                }
                .disabled(viewModel.selectedAnswer != nil)
            }
        }
        .padding(.horizontal)
    }

    private func feedbackView(for current: Item) -> some View {
        VStack(spacing: 16) {
            Group {
                if viewModel.isAnswerCorrect == true {
                    Text("🎉 Correct! +2 Points")
                        .font(.headline)
                        .foregroundColor(.green)
                    Text("Nice job! You're getting the hang of this.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("❌ Oops! That wasn’t right.")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("Don't worry—give the next one a shot!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .transition(.opacity.combined(with: .slide))

            Text(current.standFirst)
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            HStack(spacing: 12) {
                if let url = URL(string: current.storyUrl) {
                    Button(action: {
                        UIApplication.shared.open(url)
                    }) {
                        HStack {
                            Image(systemName: "book.fill")
                            Text("Read Article")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                colors: [Color.green, Color.teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                }

                Button(action: {
                    viewModel.nextQuestion()
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Next Question")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
            }
        }
        .padding(.horizontal)
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}


#Preview {
    QuizView()
}
