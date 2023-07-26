//
//  MessagesChannelListTopView.swift
//  Amare
//
//  Created by Micheal Bingham on 6/25/22.
//

import SwiftUI
import StreamChatSwiftUI
import StreamChat

struct MessagesChannelListTopView: View {
	
	
	
	@Binding var searchText: String
	
//	@EnvironmentObject var userData: UserDataModel
	
    var body: some View {
		VStack{
			SearchBar(text: $searchText)
			Text("Nearby")
			ScrollView(.horizontal, showsIndicators: true) {
				
				HStack{
					
					ForEach(0..<10) { num in
						
						ZStack{
							
							PulsingView(singleColor: Color.random(), size: 100,frequency: 1.0,  opacity: 1.0)
								
							ProfileImageView(profile_image_url: .constant(AmareUser.random().profile_image_url), size: 100)
								
							}
						.padding()
						
						
						
					}
				}
				
				
				
				
			}
		
		}
    }
}

struct MessagesChannelListTopView_Previews: PreviewProvider {
	
	//static var userData = UserDataModel()
    static var previews: some View {
		
		MessagesChannelListTopView(searchText: .constant("@hello"))
			.onAppear(perform: {
			//	userData.userData = AmareUser.random()
			})
			
			//.environmentObject(userData)
		
    }
}


struct SearchBar: View, KeyboardReadable {
	
	@Injected(\.colors) private var colors
	@Injected(\.fonts) private var fonts
	@Injected(\.images) private var images
	
	@Binding var text: String
	@State private var isEditing = false
		
	var body: some View {
		HStack {
			TextField("Search", text: $text)
                
				.padding(8)
				.padding(.leading, 8)
				.padding(.horizontal, 24)
				.background(Color(colors.background1))
				.clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
				.overlay(
					HStack {
						Image(uiImage: images.searchIcon)
						//	.customizable()
							.foregroundColor(Color(colors.textLowEmphasis))
							.frame(maxHeight: 18)
							.padding(.leading, 12)
						
						Spacer()
						
						if !self.text.isEmpty {
							Button(action: {
								self.text = ""
							}) {
								Image(uiImage: images.searchCloseIcon)
									//.customizable()
									.frame(width: 18, height: 18)
									.foregroundColor(Color(colors.textLowEmphasis))
									.padding(.trailing, 8)
							}
						}
					}
				)
				.padding(.horizontal, 8)
				.transition(.identity)
				.animation(.easeInOut, value: isEditing)
			
			if isEditing {
				Button(action: {
					self.isEditing = false
					self.text = ""
					// Dismiss the keyboard
					AmareApp().dismissKeyboard()
				}) {
					Text("Cancel")
						.foregroundColor(colors.tintColor)
				}
				.frame(height: 20)
				.padding(.trailing, 8)
				.transition(.move(edge: .trailing))
				.animation(.easeInOut)
			}
		}
		.padding(.vertical, 8)
		.onReceive(keyboardWillChangePublisher) { shown in
			if shown {
				self.isEditing = true
			}
			if !shown && isEditing {
				self.isEditing = false
			}
		}
	}
}
