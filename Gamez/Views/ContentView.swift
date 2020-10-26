//
//  ContentView.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 03/10/20.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = GameViewModel()
    @ObservedObject var favorites = Favorites()
    
    @State var presentingModal = false
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection){
            LoadingView(isShowing: $viewModel.loading) {
                NavigationView{
                    List {
                        ForEach(viewModel.games, id: \.id) { game in
                            NavigationLink(destination: GameDetailView(item: game)) {
                                GameListRow(game: game, isFavorite: self.favorites.contains(game))
                                EmptyView()
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationBarTitle("Gemaz")
                    .navigationBarItems(trailing:
                                            Button(action: {
                                                self.presentingModal = true
                                            }) {
                                                Image(systemName: "person.circle.fill")
                                                    .font(.largeTitle)
                                            }
                        .foregroundColor(.yellow)
                                            .sheet(isPresented: $presentingModal) { ProfileView(presentedAsModal: self.$presentingModal) }
                    )
                }
                .environmentObject(favorites)
            }
            .tabItem{
                selection == 0 ? Image(systemName: "doc.text.fill") : Image(systemName: "doc.text")
                Text("My Gemaz")
            }
            .tag(0)
            
            NavigationView{
                if favorites.favorites.isEmpty {
                    VStack(spacing: 50){
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        Text("No Favorite Games")
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                            .navigationBarTitle("My Favs")
                    }
                } else {
                    List {
                        ForEach(favorites.favorites, id: \.id) { favorite in
                            NavigationLink(destination: FavoriteDetailView(itemFavorite: favorite)){
                                GameFavoriteRow(favGame: favorite)
                                EmptyView()
                            }
                        }
                        .onDelete(perform: favorites.deleteGameFav)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationBarTitle("My Favs")
                }
            }
            
            .tabItem{
                selection == 1 ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                Text("My Favs")
            }
            .tag(1)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FavoriteView: View {
    @ObservedObject var favorites = Favorites()
    
    var body: some View {
        NavigationView{
            if favorites.favorites.isEmpty {
                VStack(spacing: 50){
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.yellow)
                    Text("No Favorite Games")
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .navigationBarTitle("My Favs")
                }
            } else {
                List {
                    ForEach(favorites.favorites, id: \.id) { favorite in
                        //                        NavigationLink(destination: FavoriteDetailView(itemFavorite: favorite)){
                        GameFavoriteRow(favGame: favorite)
                        //                            EmptyView()
                        //                        }
                    }
                    //                    .onDelete(perform: favorites.deleteGameFav)
                    .onDelete(perform: { offsets in
                        favorites.deleteGameFav(at: offsets)
                    })
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("My Favs")
            }
        }
    }
}

struct GameListRow: View {
    var game: Result
    var isFavorite: Bool
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: game.backgroundImage))
                .onSuccess { _, _, _ in
                }
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.yellow)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(game.name)
                    .font(.headline)
                Text(game.released)
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack{
                    Image.init(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", game.rating))
                        .font(.callout)
                }
                if isFavorite {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}

struct GameFavoriteRow: View {
    var favGame: Favorite
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: favGame.imageUrl))
                .onSuccess { _, _, _ in
                }
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.yellow)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(favGame.name)
                    .font(.headline)
                Text(favGame.released)
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack{
                    Image.init(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", favGame.rating))
                        .font(.callout)
                }
            }
        }
        .padding()
    }
}
