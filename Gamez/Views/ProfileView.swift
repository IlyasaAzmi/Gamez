//
//  ProfileView.swift
//  Gamez
//
//  Created by Ilyasa' Azmi on 11/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Binding var presentedAsModal: Bool
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: 20) {
                List {
                    HStack {
                        Spacer()
                        ZStack{
                            Circle()
                                .strokeBorder()
                                .foregroundColor(.yellow)
                                .frame(width: 120, height: 120, alignment: .center)
                            ImageFromUrlView(imageUrl: "https://d17ivq9b7rppb3.cloudfront.net/small/avatar/20200616092930830c819796784c122c785e98f97fae98.png")
                        }
                        
                        Spacer()
                    }.padding()
                    
                    ProfileRow(name: "Ilyasa' Azmi", imageName: "person")
                    ProfileRow(name: "theazmi99ilyasa@gmail.com", imageName: "envelope")
                    ProfileRow(name: "+62 852 3159 1505", imageName: "phone")
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Profile")
            .navigationBarItems(trailing:
                                    Button("Done") { self.presentedAsModal = false }
            )
        }
    }
}

struct ProfileRow: View {
    var name: String
    var imageName: String
    
    var body: some View {
        HStack{
            Image(systemName: "\(imageName)")
                .foregroundColor(.yellow)
            Spacer()
            Text(name)
                .font(.caption)
        }
    }
}

struct ImageFromUrlView: View {
    var imageUrl: String
    
    var body: some View {
        WebImage(url: URL(string: imageUrl))
            .onSuccess { _, _, _ in
            }
            .resizable()
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(width: 100, height: 100, alignment: .center)
            .clipShape(Circle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
