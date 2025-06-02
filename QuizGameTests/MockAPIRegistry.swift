//
//  MockAPIRegistry.swift
//  QuizGame

@testable import QuizGame

extension APIRegistry {
    static func registerMockConfig<T: DecodableResponse>(for key: APIKey, responseType: T.Type) {
        MockAPIRegistry.mockConfig = APIConfig(endpoint: "https://mock.endpoint", ttl: 60, responseType: responseType)
    }
}

enum MockAPIRegistry {
    static var mockConfig: Any?

    static func config(for key: APIKey) -> Any {
        if key == .mock, let config = mockConfig {
            return config
        }
        return APIRegistry.config(for: key)
    }
}
