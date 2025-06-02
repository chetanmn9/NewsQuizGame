//
//  QuizViewModel.swift
//  QuizGame

import Foundation

func makeRegistry<T: DecodableResponse>() -> (APIKey) -> APIConfig<T> {
    return { key in
        switch key {
        case .quizGame:
            return APIConfig(endpoint: "quiz-url", ttl: 120, responseType: T.self)
//            return APIConfig(endpoint: "https://firebasestorage.googleapis.com/v0/b/nca-dna-apps-dev.appspot.com/o/game.json?alt=media&token=e36c1a14-25d9-4467-8383-a53f57ba6bfe", ttl: 120, responseType: T.self)
        default:
            fatalError("Unsupported key")
        }
    }
}



@MainActor
class QuizViewModel: ObservableObject {
    @Published var quizData: QuizItem?
    @Published var currentIndex: Int = 0
    @Published var selectedAnswer: Int? = nil
    @Published var isAnswerCorrect: Bool? = nil
    @Published var score: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var imageViewModel: ImageViewModel?

    var currentItem: Item? {
        return quizData?.items[safe: currentIndex]
    }
    
    private let repository: GenericRepository
    
    init(repository: GenericRepository = .shared) {
        self.repository = repository
        Task {
            await loadQuiz()
        }
    }

    func loadQuiz() async {
        isLoading = true
        errorMessage = nil
        do {
//            let result = try await QuizDataService.shared.fetchQuizData()
            let result: QuizItem = try await repository.get(for: .quizGame, forceRefresh: false)
            self.quizData = result
            self.currentIndex = 0
            self.selectedAnswer = nil
            self.isAnswerCorrect = nil
            self.score = 0
            updateImageViewModel()
        } catch {
            errorMessage = "Failed to load quiz: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
        func selectAnswer(_ index: Int) {
            guard selectedAnswer == nil else { return }
    
            selectedAnswer = index
            isAnswerCorrect = (index == currentItem?.correctAnswerIndex)
    
            if isAnswerCorrect == true {
                score += 2
            }
        }

    func nextQuestion() {
        if let total = quizData?.items.count, currentIndex + 1 < total {
            currentIndex += 1
            selectedAnswer = nil
            isAnswerCorrect = nil
            updateImageViewModel()
        } else {
            Task {
                await loadQuiz()
            }
        }
    }

    private func updateImageViewModel() {
        if let urlString = currentItem?.httpsImageUrl,
           let url = URL(string: urlString) {
            imageViewModel = ImageViewModel(url: url)
            imageViewModel?.loadImage()
        } else {
            imageViewModel = nil
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
