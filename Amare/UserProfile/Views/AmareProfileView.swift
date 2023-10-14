//
//  AmareProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/14/23.
//

import SwiftUI


struct AmareProfileView: View {
    var body: some View {
        ZStack {
            Color.pink.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top Profile Area
                HStack {
                    Image("DianaRussellProfilePic")  // Use Image Literal or replace with your image name
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("Diana Russell ⭐")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("@dannirussell")
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    Spacer()
                    Text("74%")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.trailing)
                }
                .padding()
                
                // Social Media Links
                HStack(spacing: 15) {
                    Image(systemName: "link")
                    Image(systemName: "link")
                    Image(systemName: "link")
                }
                .foregroundColor(.white)
                .padding()
                
                // Interests
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.white)
                    Text("Reader")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "music.note")
                        .foregroundColor(.white)
                    Text("Music")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "airplane")
                        .foregroundColor(.white)
                    Text("Traveling")
                        .foregroundColor(.white)
                }
                .padding()
                
                // Action Buttons
                HStack(spacing: 30) {
                    Button(action: {}) {
                        Text("Add Friend")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    Button(action: {}) {
                        Text("Wink")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Astrological Aspects
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.7))
                        .frame(height: 150)
                    
                    Text("Ordinary life often seems drab and uninteresting to Diana and Diana must have something that stirs her imagination, some vision or ideal or dream to motivate her.")
                        .foregroundColor(.white)
                        .padding()
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct AmareProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AmareProfileView()
    }
}


#Preview {
    AmareProfileView()
}
