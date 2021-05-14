// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let bookShelf = try? newJSONDecoder().decode(BookShelf.self, from: jsonData)

import Foundation

// MARK: - BookShelf
struct BookShelf: Codable {
    var books: [Book]
}

// MARK: - Book
struct Book: Codable {
    var id, title, author, categories: String
    var year, edition: String
    var availablility: YesNo
    var bookDescription: String
    var incart, recommended: YesNo
    var volume: String?

    enum CodingKeys: String, CodingKey {
        case id, title, author, categories, year, edition, availablility
        case bookDescription = "description"
        case incart, recommended, volume
    }
}

enum YesNo: String, Codable {
    case n = "N"
    case y = "Y"
}
