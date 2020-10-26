//
//  GameDetailView.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 03/10/20.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI

struct GameDetailView: View {
    @EnvironmentObject var favorites: Favorites
    @State var gameDetail: GameDetailResponse?
    
    var item : Result
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                VStack(alignment: .leading){
                    GeometryReader { geometry in
                        ImageCarouselView(numberOfImages: item.shortScreenshots.count) {
                            ForEach(item.shortScreenshots) { ss in
                                WebImage(url: URL(string: ss.image))
                                    .onSuccess { image, data, cacheType in
                                        
                                    }
                                    .resizable()
                                    .placeholder(Image(systemName: "photo"))
                                    .placeholder {
                                        Rectangle().foregroundColor(.gray)
                                            .frame(width: UIScreen.main.bounds.width,height: 250)
                                    }
                                    .indicator(.activity) // Activity Indicator
                                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.75, alignment: .center)
                            }
                        }.frame(height: 240, alignment: .center)
                    }
                    .frame(height: 240)
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            Text("Rating: ")
                            Text(String(format: "%.1f", item.rating))
                                .font(.callout)
                            Image.init(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Spacer()
                            Button(action: {
                                if self.favorites.contains(self.item) {
                                    self.favorites.remove(self.item)
                                } else {
                                    self.favorites.addFavorite(self.item)
                                }
                            }) {
                                favorites.contains(item) ?
                                    Image(systemName: "heart.fill") : Image(systemName: "heart")
                            }
                            .padding()
                            .foregroundColor(.red)
                        }
                        Text("Released Date: \(item.released)")
                            .fontWeight(.thin)
                            .font(.caption)
                        Text(gameDetail?.descriptionRaw ?? "" )
                        Text("Available On:")
                            .font(.headline)
                        ForEach(item.platforms) { plat in
                            VStack(alignment: .leading){
                                Text("- \(plat.platform.name)")
                                    .font(.callout)
                            }
                        }
                    }
                    .padding(.leading, 18)
                    .padding(.trailing, 18)
                    
                }
            }
        }
        .navigationBarTitle("\(item.name)", displayMode: .inline)
        .onAppear {
            self.loadData(with: "\(item.id)")
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

//struct GameDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameDetailView(item: Result.)
//    }
//}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

struct ImageCarouselView<Content: View>: View {
    private var numberOfImages: Int
    private var content: Content
    
    @State private var currentIndex: Int = 0
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
            .animation(.spring())
            .onReceive(self.timer) { _ in
                
                self.currentIndex = (self.currentIndex + 1) % 3
            }
        }
    }
}
