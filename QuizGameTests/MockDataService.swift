//
//  MockDataService.swift
//  QuizGame


import Foundation
import XCTest
@testable import QuizGame

final class MockDataService: DataServiceProtocol {
    var fetchCalledCount = 0
    var mockResponse: DecodableResponse?

    func fetch<T>(from endpoint: String, as type: T.Type) async throws -> T where T : DecodableResponse {
        fetchCalledCount += 1

        guard let response = mockResponse as? T else {
            throw NSError(domain: "MockError", code: -1)
        }

        return response
    }
}
