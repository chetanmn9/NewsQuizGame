//
//  HomeView.swift
//  QuizGame


import SwiftUI

struct HomeView: View {
    @State private var navigateToQuiz = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("🧠 Headline Quiz")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Can you guess the correct headline?")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(action: {
                    navigateToQuiz = true
                }) {
                    Text("Play Quiz")
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(colors: [Color.blue, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToQuiz) {
                QuizView()
            }
        }
    }
}
