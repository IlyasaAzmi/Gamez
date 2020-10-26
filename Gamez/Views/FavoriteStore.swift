//
//  FavoriteStore.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 18/10/20.
//

import Foundation

class FavoriteStore: ObservableObject {
    static let defaultFavorites = [Favorite]()
}

class Favorites: ObservableObject, Identifiable {
    
    @Published var favorites = loadFavorites() {
        didSet {
            persistGames()
        }
    }
    
    static private let saveKey = "Favorites"
    
    static func loadFavorites() -> [Favorite] {
        let savedGames = UserDefaults.standard.object(forKey: Favorites.saveKey)
        if let savedFavorites = savedGames as? Data {
            let decoder = JSONDecoder()
            return (try? decoder.decode([Favorite].self, from: savedFavorites))
                ?? FavoriteStore.defaultFavorites
        }
        return FavoriteStore.defaultFavorites
    }
    
    func contains(_ result: Result) -> Bool {
        favorites.contains { $0.id == result.id }
    }
    
    func addFavorite(_ result: Result) {
        objectWillChange.send()
        let newFavorite = Favorite(id: result.id, name: result.name, released: result.released, rating: result.rating, imageUrl: result.backgroundImage)
        favorites.append(newFavorite)
    }

    func remove(_ result: Result) {
        objectWillChange.send()
        if let idx = favorites.firstIndex(where: { $0.id == result.id }) {
            favorites.remove(at: idx)
        }
    }
    
    func deleteGameFav(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
    }
    
    private func persistGames() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: Favorites.saveKey)
        }
    }
}
