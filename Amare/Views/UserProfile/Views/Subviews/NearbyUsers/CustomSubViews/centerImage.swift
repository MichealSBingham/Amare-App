//
//  centerImage.swift
//  Amare
//
//  Created by Micheal Bingham on 10/13/23.
//

import SwiftUI

//TODO: - flipping animation (card flip)
/// If awaiting connection, this is the location icon, otherwise this should animate to the other user's profile pic
///  -TODO:
struct centerImage: View {
    
    @Binding var connected: Bool
    @State var showOtherImage : Bool = false
    
     @Binding var profile_image_url: String?
    
     var size: CGFloat = CGFloat(80)
    
    var profileImageSize: CGFloat = CGFloat(150)
    
    @State private var condition: Bool = false
    
    var animation: Animation =
    Animation.easeInOut(duration: 1)
       .repeatForever(autoreverses: true)
    
    
    
    @Binding var animationSpeed: SpeedOfAnimation
    
    @State var speed = 1.0
    
    var body: some View {
        
        //Location image
        
        ZStack{
    
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(.white)
                    .opacity(showOtherImage ? 0: 1 )
                    
                    //.animation(animation)
                    
            
            ProfileImageView(profile_image_url: $profile_image_url, size: profileImageSize)
                .opacity(showOtherImage ? 1: 0 )
            
            
            
            
        }
        .scaleEffect(condition ? 0.9 : 1.0)
        .onChange(of: animationSpeed, perform: { newValue in
            
            condition = false
            var speed = 0.0
    
            switch newValue {
            case .slow:
                speed = 2
            case .normal:
                speed = 1
            case .medium:
                speed = 0.5
            case .fast:
                speed = 0.1
            }
        
            
            DispatchQueue.main.async {
                
                print("Setting speed to ... \(speed) ")
                withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
                    condition = true
                }
            }
            
        })
        .onAppear {
            
            
            
        
            DispatchQueue.main.async {
                
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    condition = true
                }
            }
            
        }
    
        .onChange(of: connected) { isConnected in
            
            
            withAnimation {
                showOtherImage = connected
            }
        }
    
    }
}



#Preview {
    
        
        centerImage(connected: .constant(true), profile_image_url: .constant(AppUser.generateMockData().profileImageUrl!), animationSpeed: .constant(SpeedOfAnimation.fast))
            .preferredColorScheme(.dark)
    
    
}
