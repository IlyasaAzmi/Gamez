//
//  GameDBAPI.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 03/10/20.
//

import Foundation
import Combine

enum GameDB {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://api.rawg.io/api/")!
}

enum APIPath: String {
    case generalRandomGames = "games"
}

extension GameDB {
    
    static func request(_ path: APIPath) -> AnyPublisher<GameResponse, Error> {
        guard var components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [URLQueryItem(name: "page_size", value: "20")]
        components.queryItems = [URLQueryItem(name: "page", value: "1")]
        
        let request = URLRequest(url: components.url!)
        
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
}

