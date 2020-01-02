//
//  BookModel.swift
//  Hyped Books
//
//  Created by Азизбек on 02.01.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation


// MARK: - Books
struct Books: Decodable {
    let books: [Book]
    let title: String
}

// MARK: - Book
struct Book: Decodable {
    let annotation, authors: String
    let authorsObjects: [AuthorsObject]
    let cover: Cover
    let language: String
//    let libraryCard: null
    let paperPages: Int
    let restrictedReadingOnWeb: Bool
    let title, uuid: String
    let bookshelvesCount, impressionsCount, quotesCount, readersCount: Int
    let canBeRead, inLibrary, inWishlist: Bool
    let labels: [Label]
//    let subscriptionLevel: String

    enum CodingKeys: String, CodingKey {
        case annotation, authors
        case authorsObjects = "authors_objects"
        case cover, language
//        case libraryCard = "library_card"
        case paperPages = "paper_pages"
        case restrictedReadingOnWeb = "restricted_reading_on_web"
        case title, uuid
        case bookshelvesCount = "bookshelves_count"
        case impressionsCount = "impressions_count"
        case quotesCount = "quotes_count"
        case readersCount = "readers_count"
        case canBeRead = "can_be_read"
        case inLibrary = "in_library"
        case inWishlist = "in_wishlist"
        case labels
//        case subscriptionLevel = "subscription_level"
    }
}

// MARK: - AuthorsObject
struct AuthorsObject: Codable {
    let name: String
    let locale: String
    let uuid: String
    let worksCount: Int

    enum CodingKeys: String, CodingKey {
        case name, locale, uuid
        case worksCount = "works_count"
    }
}

//enum Language: String, Decodable {
//    case ru = "ru"
//}
// MARK: - Cover
struct Cover: Codable {
    let large: String
    let placeholder: String
    let ratio: Double
    let small: String
}

// MARK: - Label
struct Label: Codable {
    let title:String
    let kind: String
}

