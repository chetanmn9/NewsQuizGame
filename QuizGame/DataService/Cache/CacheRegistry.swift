//
//  CacheRegistry.swift
//  QuizGame

import Foundation

final class CacheRegistry<Key: Hashable, Value> {
    struct CacheEntry {
        let value: Value
        let timestamp: Date
        let ttl: TimeInterval
    }

    private var cache: [Key: CacheEntry] = [:]

    func set(_ value: Value, for key: Key, ttl: TimeInterval) {
        cache[key] = CacheEntry(value: value, timestamp: Date(), ttl: ttl)
        print("##### cache set: \(cache[key])")
    }

    func get(for key: Key) -> Value? {
        let entry = cache[key]
        guard let entry = cache[key] else { return nil }
        let age = Date().timeIntervalSince(entry.timestamp)
        return age <= entry.ttl ? entry.value : nil
    }

    func invalidate(for key: Key) {
        cache.removeValue(forKey: key)
    }

    func invalidateAll() {
        cache.removeAll()
    }
}
