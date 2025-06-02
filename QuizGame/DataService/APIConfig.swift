//
//  APIConfig.swift
//  QuizGame

import Foundation

protocol DecodableResponse: Decodable {}

extension Array: DecodableResponse where Element: Decodable {}

struct APIConfig<ResponseType: DecodableResponse> {
    let endpoint: String
    let ttl: TimeInterval
    let responseType: ResponseType.Type
}
