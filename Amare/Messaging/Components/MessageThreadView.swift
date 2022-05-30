//
//  MessageThreadView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/30/22.
//

import SwiftUI
import FirebaseAuth

struct MessageThreadView: View {
	
	@Binding var thread: MessageThread
	
	//MARK: - Only for testing in preview
 /// Helps preview understand if this is a sent or received messsage, should be nil in production
	var me_for_testing: AmareUser? = nil
	/// Helps preview understand if this is a sent or received messsage, should be nil in production
	var them_for_testing: AmareUser? = nil
	var test_mode: Bool = false
	
	
	
	//TODO: - Group messages
	var thumbNail: String? {
		
		guard !test_mode else {
			// in test mode
			if thread.type == .twoWay {
				
				return them_for_testing?.profile_image_url
				
			} else {
				//TODO: group messages
				return nil
			}
		}
		if thread.type != .twoWay {
			return thread.thumbnailURL
		} else {
			
			// return the user that is NOT me
			return thread.otherUser?.profile_image_url
		}
	}
	
    var body: some View {
		HStack {
			/*
							ZStack {
								readIndicator
									.frame(width: 11, height: 11)
								Image(item.unreadIndicator)
							}
			*/

					
			
			ProfileImageView(profile_image_url: thread.thumbnailURL, size: CGFloat(100))
				
				//.border(.white)
		
							VStack(alignment: .leading){
								HStack{
									Text("\(!test_mode ? (thread.otherUser?.name ?? "No name") : them_for_testing!.name!)")
										.font(.title2).bold()
										.lineLimit(1)

									Spacer()

									Text("\(thread.lastModified.timeStampForMessages())")
										.font(.caption)
										.foregroundColor(.secondary)

									Image(systemName: "chevron.forward")
										.font(.caption)
										.foregroundColor(.secondary)
								}

								Text("\(thread.lastMessage?.text ?? "")")
									.font(.subheadline)
									.lineLimit(3)
									.foregroundColor(.secondary)
									.padding(.top, 1)
							}
						}
    }
}

struct MessageThreadView_Previews: PreviewProvider {
    static var previews: some View {
		var me = AmareUser.random()
		var them = AmareUser.random()
		
		var thread = MessageThread.randomThread(with: me, and: them)
	
		MessageThreadView(thread: .constant(thread), me_for_testing: me, them_for_testing: them, test_mode: true)
			.onAppear(perform: {
				//thread.lastMessage = Message.random(with: me, and: them)
			})
			.onTapGesture {
				me = AmareUser.random()
				them = AmareUser.random()
				thread.lastMessage = Message.random(with: me, and: them)
			}
			.preferredColorScheme(.dark)
    }
}

extension Date {
	func timeStampForMessages() -> String {
		let formatter = DateFormatter()
		
		// same day, no need to show date, just time
		if self.day() == Date().day() {
			formatter.timeStyle = .short
		} else {
			// Not same date, no need to show time
			formatter.dateStyle = .short
		}
		
		
		
		return formatter.string(from: self)
	}
}
