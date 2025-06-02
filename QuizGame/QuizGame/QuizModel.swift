//
//  QuizModel.swift
//  QuizGame


import Foundation

struct QuizItem: Identifiable, DecodableResponse { //,Decodable
    var id = UUID()
    let product: String
    let resultSize: Int
    let version: Int
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case product, resultSize, version, items
    }
}

struct Item: Identifiable, Decodable {
    var id = UUID()
    let correctAnswerIndex: Int
    let imageUrl: String
    let standFirst: String
    let storyUrl: String
    let section: String
    let headlines: [String]
    
    var httpsImageUrl: String {
        return imageUrl.replacingOccurrences(of: "http://", with: "https://")
    }

    enum CodingKeys: String, CodingKey {
        case correctAnswerIndex, imageUrl, standFirst, storyUrl, section, headlines
    }
}
