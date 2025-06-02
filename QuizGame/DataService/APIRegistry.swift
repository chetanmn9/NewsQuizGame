//
//  APIRegistry.swift
//  QuizGame


struct APIRegistry {
    static func config(for key: APIKey) -> Any {
        switch key {
        case .quizGame:
            return APIConfig(endpoint: "https://firebasestorage.googleapis.com/v0/b/nca-dna-apps-dev.appspot.com/o/game.json?alt=media&token=e36c1a14-25d9-4467-8383-a53f57ba6bfe", ttl: 120, responseType: QuizItem.self)
        case .users:
            return APIConfig(endpoint: "https://firebasestorage.googleapis.com/v0/b/nca-dna-apps-dev.appspot.com/o/game.json?alt=media&token=e36c1a14-25d9-4467-8383-a53f57ba6bfe", ttl: 120, responseType: QuizItem.self)
        case .products(let category):
            return APIConfig(endpoint: "https://firebasestorage.googleapis.com/v0/b/nca-dna-apps-dev.appspot.com/o/game.json?alt=media&token=e36c1a14-25d9-4467-8383-a53f57ba6bfe", ttl: 120, responseType: QuizItem.self)
        }
    }
}
