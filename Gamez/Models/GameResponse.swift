//
//  Game.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 03/10/20.
//

import Foundation
import Combine

// MARK: - GameResponse
struct GameResponse: Codable {
    var results: [Result]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

// MARK: - Result
struct Result: Codable, Identifiable {
    var id: Int
    var slug, name, released: String
    var tba: Bool
    var backgroundImage: String
    var rating: Double
    var ratingTop: Int
    var ratings: [Rating]
    var ratingsCount, reviewsTextCount, added: Int
    var metacritic, playtime, suggestionsCount: Int
    var userGame: String?
    var reviewsCount: Int
    var platforms: [PlatformElement]
    var parentPlatforms: [ParentPlatform]
    var shortScreenshots: [ShortScreenshot]

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case userGame = "user_game"
        case reviewsCount = "reviews_count"
        case platforms
        case parentPlatforms = "parent_platforms"
        case shortScreenshots = "short_screenshots"
    }
}

// MARK: - ParentPlatform
struct ParentPlatform: Codable {
    var platform: ParentPlatformPlatform
}

// MARK: - ParentPlatformPlatform
struct ParentPlatformPlatform: Codable {
    var id: Int
    var name: Name
    var slug: Slug
}

enum Name: String, Codable {
    case android = "Android"
    case appleMacintosh = "Apple Macintosh"
    case iOS = "iOS"
    case linux = "Linux"
    case nintendo = "Nintendo"
    case pc = "PC"
    case playStation = "PlayStation"
    case xbox = "Xbox"
}

enum Slug: String, Codable {
    case android = "android"
    case ios = "ios"
    case linux = "linux"
    case mac = "mac"
    case nintendo = "nintendo"
    case pc = "pc"
    case playstation = "playstation"
    case xbox = "xbox"
}

// MARK: - PlatformElement
struct PlatformElement: Codable, Identifiable {
    var id = UUID()
    var platform: PlatformPlatform
    var releasedAt: String

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
    }
}

// MARK: - PlatformPlatform
struct PlatformPlatform: Codable {
    var id: Int
    var name, slug: String
    var image, yearEnd: String?
    var yearStart: Int?
    var gamesCount: Int
    var imageBackground: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case yearEnd = "year_end"
        case yearStart = "year_start"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Rating
struct Rating: Codable {
    var id: Int
//    var title: Title
    var count: Int
    var percent: Double
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Codable, Identifiable {
    var id: Int
    var image: String
}
