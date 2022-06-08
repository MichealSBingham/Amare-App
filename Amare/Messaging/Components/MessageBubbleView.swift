//
//  MessageBubbleView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
struct MessageBubbleView: View {
	
	@Binding var message: Message
	
	
	/// Status of message: delivered, read, etc
	@State private var showMessageStatus: Bool = false
	
	
	//MARK: - ONLY for test purposees
/// Default false. Only set to true for preview
	 var testMode: Bool = false
	/// Helps preview understand if this is a sent or received messsage, should be nil in production
	 var me: AmareUser?
	/// Helps preview understand if this is a sent or received messsage, should be nil in production

	 var them: AmareUser?
	
	
	/// Returns if this message was sent by the current signed in user or not
	 var sentMessage: Bool {
		 
		 guard !testMode else {
			 
			 return message.sentBy.id == me?.id ?? "" 
		 }
		
		return message.sentBy.userId == Auth.auth().currentUser?.uid ?? ""
	}
	
	var messageStatusString: String {
		if sentMessage{
			
			if message.type == .twoWay{
				// show read/ignored/etc status
				if message.readBy.isEmpty {
					// hasn't been read by anyone
					return "**Delivered** \(message.sentAt.timeAgoDisplay())"
					
				}
				
				guard message.readWhen != nil else { return "**Delivered** \(message.sentAt.timeAgoDisplay())"}
				// read
				return "**Read** \(message.readWhen!.timeAgoDisplay())"
			} else{
				// group message
				//TODO: Handle ignored/read/etc
				
				if message.readBy.isEmpty {
					// read by no one
					return "**Delivered** \(message.sentAt.timeAgoDisplay())"
				}
				
				return "**Read**"
			}
		} else{
			// Message was sent to me
			if message.type == .twoWay{
				// Only need to show when sent
				return "**Sent** \(message.sentAt.timeAgoDisplay())"
			} else {
				
				// Group message
				
				if message.readBy.isEmpty {
					// read by no one
					return "**Delivered** \(message.sentAt.timeAgoDisplay())"
				}
				
				return "**Read**"
			}
			
			
			
		}
	}
	
    var body: some View {
       
		// if sent by me, align to the right
		VStack(alignment: sentMessage ? .trailing : .leading){
			
			HStack{
				
				Text(message.text)
					
					.padding()
					.background(!sentMessage ? AnyView(Background()) : AnyView(Background().colorInvert()))
					.grayscale(sentMessage ? 1 : 0 )
					
					.foregroundColor(.white)
					.foregroundStyle(.ultraThinMaterial)
					.cornerRadius(30)
				
			}
			.frame(maxWidth: 300, alignment: sentMessage ? .trailing : .leading)
			.onTapGesture {
				withAnimation {
					showMessageStatus.toggle()
				}
			}
			
		//	Text("\(message.sentAt.formatted(.dateTime.day().hour().minute()))")
			Text(try! AttributedString(markdown: messageStatusString))
				//.font(.caption2)
				.opacity(showMessageStatus || message.lastMessage ? 1: 0 )
				.padding(sentMessage ? .trailing : .leading, 10)
			
		}
		.frame(maxWidth: .infinity, alignment: sentMessage ? .trailing : .leading)
		.padding(sentMessage ? .trailing : .leading)
		//.padding(.horizontal, 10)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
		MessageBubbleView(message: .constant(Message(id: "5", thread: UUID().uuidString, text: "Cups of the XO... all my people been here.. I see all of my friends are here... guess she don't have the time to kick it no more.. Flights in the morning... but what are you doing that's so important?? I've been drinking so much... I'ma call you anyway and say ...", sentBy: AmareUser(id: "3", name: "Kara Scott", profile_image_url: mockProfileImageURL), sentAt: Date(), readBy: [], type: .twoWay)))
			.preferredColorScheme(.dark)
    }
}
