//
//  DataService.swift
//  QuizGame


import Foundation

protocol DataServiceProtocol {
    func fetch<T: DecodableResponse>(from endpoint: String, as type: T.Type) async throws -> T
}

final class DataService: DataServiceProtocol {
    func fetch<T: DecodableResponse>(from endpoint: String, as type: T.Type) async throws -> T {
        let url = URL(string: endpoint)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
