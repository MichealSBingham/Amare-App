//
//  UserProfileView.swift
//  Amare
//
//  Created by Micheal Bingham on 7/26/23.
//

import SwiftUI



struct UserProfileView: View {
	
	@StateObject  var model: UserProfileModel
	
	fileprivate func winkStatusLabel() -> some View {
		return Text((model.winkedAtMe ?? false) ? "\(model.user?.name ?? "") 😉 at you" : "")
			.fontWeight(.light)
	}
	
	
	fileprivate func nameAndAgeLabel() -> some View {
		return HStack{
			
			Text(model.user?.name ?? "")
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding(.horizontal)
			Spacer()
			Text(model.user?.birthday.approximateAgeText() ?? "")
				.font(.title)
				.fontWeight(.light)
				.padding(.horizontal)
		}
	}
	
	var body: some View {
		VStack{
			
			ImageForUserProfileView(profile_image_url: model.user?.profileImageUrl  )
				//.frame(width: 200, height: 200)
			
			winkStatusLabel()
			
			
			nameAndAgeLabel()
			.padding(.top)
			
			NatalChartTabView()
			
		}
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
		UserProfileView(model: UserProfileModel.previewInstance())
			//.environmentObject(UserProfileModel.previewInstance())
    }
}
