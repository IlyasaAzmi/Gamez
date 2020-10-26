//
//  GameViewModel.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 03/10/20.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    
    @Published var loading = false
    @Published var games: [Result] = []
    @Published var detailGames: Result?
    
    var cancellationToken: AnyCancellable?
    
    init() {
        getGames()
    }
    
}

extension GameViewModel {
    
    func getGames() {
        self.loading = true
        cancellationToken = GameDB.request(.generalRandomGames)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.games = $0.results
                    self.loading = false
                  })
    }
    
}
