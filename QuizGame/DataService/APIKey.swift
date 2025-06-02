//
//  APIKey.swift
//  QuizGame

import Foundation

enum APIKey: Hashable {
    case quizGame
    case users
    case products(category: String)
}
