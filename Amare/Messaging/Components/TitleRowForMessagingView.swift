//
//  TitleRowForMessagingView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI
import FirebaseAuth
let mockProfileImageURL = "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80"

struct TitleRowForMessagingView: View {
	
	
	
	@Binding var thread: MessageThread
//	@Binding var thread: MessageThread
	
	var them: AmareUser {
		
		guard Auth.auth().currentUser != nil else {
			return thread.members.randomElement()!
		}
	
		return thread.members.first(where: {$0.id == Auth.auth().currentUser!.uid} )!
		
	}
    var body: some View {
		VStack{
			
			if thread.type == .twoWay {
				
				HStack{
					
					ProfileImageView(profile_image_url: them.profile_image_url ?? mockProfileImageURL)
					//	.padding([.top, .bottom], -20)
					
					VStack{
						
						Text(them.name)
							.font(.title).bold()
							//.padding(-5)
						Text(them.username)
							.font(.caption)
						
					}
					
					Spacer()
				}
				
				
					
				
				
			} else {
				Text("No support for groups yet. Working on it. ")
			}
			
			
		}
		.frame(maxWidth: .infinity)
		.background(.ultraThinMaterial)
		.foregroundColor(Color.primary.opacity(0.35))
		.foregroundStyle(.ultraThinMaterial)
		.cornerRadius(20)
		
	
		//.padding()
		
		
		
    }
}

struct TitleRowForMessagingView_Previews: PreviewProvider {
    static var previews: some View {
		
		TitleRowForMessagingView(thread: .constant(MessageThread.randomThread()))
			
    }
}
