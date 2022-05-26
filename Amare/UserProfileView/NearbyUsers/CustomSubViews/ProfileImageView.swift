//
//  ProfileImageView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/26/22.
//

import SwiftUI
import URLImage

//TODO: - If user is a ghost/mystery person, should show a question mark as profile pic or ghost photo
// Profile Image for NearbyUser, making this a button in case it can be useful somehow
struct ProfileImageView: View {
	
	@Binding var profile_image_url: String?
	var size: CGFloat = CGFloat(80)
	
	@State var condition: Bool = false
	@State var condition2: Bool = false

	
	var FastAnimation: Animation {
		Animation.easeInOut
		.repeatForever(autoreverses: false)
	}
	
	@State var animation: Animation =
		Animation.easeInOut(duration: 1)
		.repeatForever(autoreverses: true) {
			
			didSet{
				condition.toggle()
				condition2.toggle()
			}
		}
	
	
	// Regular speed for pulsing animation
	var RegularAnimation: Animation =
	Animation.easeInOut(duration: 1)
	   .repeatForever(autoreverses: true)
	
	var VerySlowAnimation: Animation {
		Animation.easeInOut(duration: 2)
		.repeatForever(autoreverses: true)
	}
	
	
    var body: some View {
        
		Button {
			
			
			
		  
			
		} label: {
			
			
			
		  
			URLImage(URL(string: profile_image_url ?? "https://findamare.com")!) { progress in
				
				
				Image(systemName: "person.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.clipShape(Circle())
					.foregroundColor(.white)
					// .frame(width: 100, height: 100)
					 .shadow(radius: 15)
					 .frame(width: size, height: size)
					 .scaleEffect(condition ? 0.9 : 1.0)
					 .animation(animation)
					 .onAppear {
						
						 DispatchQueue.main.async {
							 
							 withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)) {
								 condition = true
							 }
						 }
					 }
					 
					 
				
			}
			
		failure: {  error,retry in
			
			//Image(systemName: "person.fill.questionmark")
			Image(systemName: "person.circle.fill")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.foregroundColor(.white)
				.clipShape(Circle())
				// .frame(width: 100, height: 100)
				 .shadow(radius: 15)
				 .frame(width: size, height: size)
				 .scaleEffect(condition2 ? 0.8 : 1.0)
				 .animation(animation)
				 
				 .onAppear {
					
					 DispatchQueue.main.async {
						 
						 withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)) {
							 condition2 = true
						 }
					 }
				 }
		}
		
		
		content: { image, info in
				
			
			ZStack{
				
				
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
					.clipShape(Circle())
					.foregroundColor(.white)
					 .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
					 .shadow(radius: 15)
					 .frame(width: size, height: size)
					 .opacity(profile_image_url != nil ? 1: 0)
				
				Image(systemName: "person.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.clipShape(Circle())
					// .frame(width: 100, height: 100)
					 .shadow(radius: 15)
					 .frame(width: size, height: size)
					 .redacted(reason: .placeholder)
					// .blur(radius: condition ? 0.0 : 4.0)
					 .scaleEffect(condition ? 0.9 : 1.0)
					 .animation(animation)
	 
				
					// .opacity(user.profile_image_url == nil ? 1: 0)
					 .onAppear {
						
						 DispatchQueue.main.async {
							 
							 withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)) {
								 condition = true
							 }
						 }
					 }
			}
			
		}
		

		

	}
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
		ProfileImageView(profile_image_url: .constant(nil))
			.preferredColorScheme(.dark)
    }
}



