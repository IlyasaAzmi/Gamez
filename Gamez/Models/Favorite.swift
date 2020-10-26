//
//  Favorite.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 18/10/20.
//

import Foundation

struct Favorite: Codable, Identifiable {
    let id: Int
    let name: String
    let released: String
    let rating: Double
    let imageUrl: String
}
