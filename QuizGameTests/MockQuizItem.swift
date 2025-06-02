//
//  MockQuizItem.swift
//  QuizGame

@testable import QuizGame
import XCTest

struct MockQuizItem: DecodableResponse, Equatable {
    let title: String
}
