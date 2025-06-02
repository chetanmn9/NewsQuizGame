//
//  QuizGameTests.swift
//  QuizGameTests


@testable import QuizGame
import XCTest
    
final class GenericRepositoryTests: XCTestCase {

    var mockDataService: MockDataService!
    var repository: GenericRepository!

    override func setUp() {
        super.setUp()
        mockDataService = MockDataService()
        repository = TestGenericRepository(dataService: mockDataService)
        APIRegistry.registerMockConfig(for: .mock, responseType: MockQuizItem.self)
    }

    func test_get_fetchesDataAndCachesIt() async throws {
        // Given
        let expected = MockQuizItem(title: "Test Quiz")
        mockDataService.mockResponse = expected
                
        // When
        let result: MockQuizItem = try await repository.get(for: .mock)

        // Then
        XCTAssertEqual(result, expected)
        XCTAssertEqual(mockDataService.fetchCalledCount, 1)

        // Call again to test cache
        let cachedResult: MockQuizItem = try await repository.get(for: .mock)

        XCTAssertEqual(cachedResult, expected)
        XCTAssertEqual(mockDataService.fetchCalledCount, 1, "Should not fetch again; should use cache")
    }

    func test_get_afterInvalidateCache_fetchesAgain() async throws {
        // Given
        let expected = MockQuizItem(title: "Test Quiz")
        mockDataService.mockResponse = expected

        // When
        let result1: MockQuizItem = try await repository.get(for: .mock)
        repository.invalidateCache(for: .mock)
        let result2: MockQuizItem = try await repository.get(for: .mock)

        // Then
        XCTAssertEqual(result1, expected)
        XCTAssertEqual(result2, expected)
        XCTAssertEqual(mockDataService.fetchCalledCount, 2, "Fetch should be called again after invalidating cache")
    }
}

final class TestGenericRepository: GenericRepository {
    override func get<T: DecodableResponse>(for key: APIKey, forceRefresh: Bool = false) async throws -> T {
        guard let config = MockAPIRegistry.config(for: key) as? APIConfig<T> else {
            throw NSError(domain: "Invalid config type", code: -1)
        }

        if let cached = cache.get(for: key) as? T {
            return cached
        }

        let result: T = try await dataService.fetch(from: config.endpoint, as: config.responseType)
        cache.set(result, for: key, ttl: config.ttl)
        return result
    }
}
