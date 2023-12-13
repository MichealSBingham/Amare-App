//
//  PicturesCollectionView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/17/23.
//

import SwiftUI
import SDWebImageSwiftUI


struct IdentifiableImage: Identifiable {
    let id = UUID() // Unique identifier
    let imageUrl: String
}


struct PicturesCollectionView: View {
    var images: [String] = []
    var isSignedInUser: Bool = false
    @State var selectedImage: IdentifiableImage?
    @State var showNewImageUpload: Bool = false
    @EnvironmentObject var signedInUserDataModel: UserProfileModel
    @StateObject var viewedUserModel: UserProfileModel

    var body: some View {
        GeometryReader { geometry in
            let width = floor(geometry.size.width / 3) // Use floor to round down

            ZStack{
                ScrollView {
                    LazyVGrid(columns: [GridItem(.fixed(width), spacing: 0), GridItem(.fixed(width), spacing: 0), GridItem(.fixed(width))], spacing: 0) {
                        ForEach(images, id: \.self) { imageUrl in
                            WebImage(url: URL(string: imageUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: width) // Use dynamic width
                                .clipped()
                                .overlay(Rectangle().stroke(Color.black, lineWidth: 0.5))
                                .onTapGesture {
                                    selectedImage = IdentifiableImage(imageUrl: imageUrl)
                                }
                        }
                        
                        if isSignedInUser{
                            
                            Button {
                                showNewImageUpload.toggle()
                            } label: {
                                
                                Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                        .frame(width: width, height: width)
                                        .background(Color.secondary.opacity(0.1))
                                        .overlay(Rectangle().stroke(Color.black, lineWidth: 0.5))
                            }
                            .buttonStyle(.plain)

                        }
                       
                        
                    }
                }
                .padding(0)
                .blur(radius: viewedUserModel.friendshipStatus == .friends || (viewedUserModel.user?.id == signedInUserDataModel.user?.id) ? 0 : 3.0)
                .brightness(viewedUserModel.friendshipStatus == .friends || (viewedUserModel.user?.id == signedInUserDataModel.user?.id) ? 0: -0.5)
                .disabled( !(viewedUserModel.friendshipStatus == .friends || (viewedUserModel.user?.id == signedInUserDataModel.user?.id)) )
                          
                
                Color.black
                    .opacity(viewedUserModel.friendshipStatus == .friends || (viewedUserModel.user?.id == signedInUserDataModel.user?.id) ? 0: 0.8)
                    
                
                Text("This profile is private, send a friend request.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.01)
                    .opacity(viewedUserModel.friendshipStatus == .friends || (viewedUserModel.user?.id == signedInUserDataModel.user?.id) ? 0 : 1)
                    .offset(y:-100)
                
            }
            
        }
        .sheet(item: $selectedImage) { imageUrl in
            FullScreenImageView(imageUrl: imageUrl.imageUrl)
        }
        .sheet(isPresented: $showNewImageUpload, content: {
            UploadNewImageView()
                .environmentObject(signedInUserDataModel)
        })
    }
}



struct FullScreenImageView: View {
    let imageUrl: String

    var body: some View {
        WebImage(url: URL(string: imageUrl))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
    }
}






#Preview {
    PicturesCollectionView(images: peopleImages, viewedUserModel: UserProfileModel())
}
