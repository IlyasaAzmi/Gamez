//
//  FavoriteDetailView.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 20/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteDetailView: View {
    @ObservedObject var viewModel = GameViewModel()
    @ObservedObject var favorites = Favorites()
    @State var itemFavorite: Favorite
    @State var gameDetail: GameDetailResponse?
    
    @State var isLoading = false
    
    var body: some View {
        ScrollView{
            VStack{
                if gameDetail?.backgroundImage != nil {
                    WebImage(url: URL(string: gameDetail?.backgroundImage ?? ""))
                        .onSuccess { _, _, _ in
                        }
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: 250, alignment: .center)
                }
                
                Text(itemFavorite.name)
                    .font(.title)
                Text(gameDetail?.descriptionRaw ?? "No Description")
                    .padding()
            }
        }
        
        .onAppear {
            self.loadData(with: "\(itemFavorite.id)")
        }
    }
    
    func loadData(with id: String) {
        guard let url = URL(string: "https://api.rawg.io/api/games/\(id)") else {
            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(GameDetailResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.gameDetail = response
                    }
                    return
                }
            }
        }.resume()
    }
}

//struct FavoriteDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteDetailView()
//    }
//}
