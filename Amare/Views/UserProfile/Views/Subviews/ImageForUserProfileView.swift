//
//  ImageForUserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/23.
//

import SwiftUI
import URLImage


struct ImageForUserProfileView: View {
	
	var profile_image_url: String?
	
	var body: some View {
		
		
		
		
		  URLImage(URL(string: profile_image_url ?? "https://via.placeholder.com/150")!) { progress in
			  
			  
			  Image(systemName: "person.circle.fill")
				  .resizable()
				  .aspectRatio(contentMode: .fill)
				  .frame(width: 400, height: 250, alignment: .center)
				  .clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
			
				   
			  
		  }
		  
	  failure: {  error,retry in
		  
		  
		  Image(systemName: "person.circle.fill")
			  .resizable()
			  .foregroundColor(.white)
			  .aspectRatio(contentMode: .fill)
			  .frame(width: 400, height: 250, alignment: .center)
			  .clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
			  
	  }
	  
	  
	  content: { image, info in
			  
		  
		  ZStack{
			  
			  
			  image
				  .resizable()
				  .aspectRatio(contentMode: .fill)
				  .frame(width: 400, height: 250, alignment: .center)
				  .clipShape(RoundedRectangle(cornerRadius: CGFloat(25)))
			  
		  }
		  
	  }
	}
}

struct ImageForUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
		ImageForUserProfileView(profile_image_url: AppUser.generateMockData().profileImageUrl)
    }
}

