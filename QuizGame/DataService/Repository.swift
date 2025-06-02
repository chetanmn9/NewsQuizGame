//
//  Repository.swift
//  QuizGame

import Foundation

class GenericRepository {
    let dataService: DataServiceProtocol
    let cache = CacheRegistry<APIKey, Any>()
    static let shared = GenericRepository()
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
    }

    func get<T: DecodableResponse>(for key: APIKey, forceRefresh: Bool = false) async throws -> T {
        print("##### key: \(key)")
        let apiRegistry = APIRegistry.config(for: key)
        print("##### apiRegistry: \(apiRegistry)")
        print("##### APIConfig<T>: \(APIConfig<T>.self)")
        let config = APIRegistry.config(for: key) as? APIConfig<T>
        guard let config = APIRegistry.config(for: key) as? APIConfig<T> else {
            throw NSError(domain: "Invalid config type", code: -1)
        }

        if let cached = cache.get(for: key) as? T {
            return cached
        }

        let result: T = try await dataService.fetch(from: config.endpoint, as: config.responseType)
        cache.set(result, for: key, ttl: config.ttl)
        return result
    }

    func invalidateCache(for key: APIKey) {
        cache.invalidate(for: key)
    }
}
