//
//  Marvel.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import Foundation

struct MarvelKeyDecoder: Decodable {
    var publicKey: String
    var privateKey: String
}
// MARK: - Welcome
struct Characters: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail
    let comics, series: Comics
    let stories: Stories
    let events: Comics
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int
    let collectionURI: String
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int
    let collectionURI: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
    
    var thumbnailURL: String {
        return path + "." + thumbnailExtension
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let url: String
}
