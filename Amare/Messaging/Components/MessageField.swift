//
//  MessageField.swift
//  Amare
//
//  Created by Micheal Bingham on 6/3/22.
//

import SwiftUI
import FirebaseAuth

struct MessageField: View {
	
	@EnvironmentObject var conversationData: ConversationDataStore
	@EnvironmentObject var signedInUserData: UserDataModel
	@State private var message = ""
	
	var thread: MessageThread
    var body: some View {
        
		HStack{
			CustomMessageField(text: $message)
			
			Button {
				//
				print("Message sent")
				
				guard let me = Auth.auth().currentUser?.uid else { return }
				
				let msg = Message(id: UUID().uuidString, thread: thread.id!, text: message, sentBy: signedInUserData.userData, sentAt: Date(), readBy: [], ignoredBy: [], tooBusyToReply: [], readWhen: nil, type: thread.type)
		
				conversationData.send(this: msg, to: thread)
				message = ""
			} label: {
				Image(systemName: "paperplane.fill")
					.padding(10)
					.foregroundColor(.red)
					//background(Color(.gray))
					.foregroundStyle(.ultraThinMaterial)
					.cornerRadius(50)
					
			}

			
	
				
		}
		.padding(.horizontal)
		.padding(.vertical, 10)
		//.background(Color(UIColor.darkGray))
		.cornerRadius(50)
		.overlay(
					RoundedRectangle(cornerRadius: 50)
						.stroke(Color.gray, lineWidth: 0.5)
				)
		.padding()
		
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
		MessageField( thread: MessageThread.randomThread())
			.preferredColorScheme(.dark)
	}
}


struct CustomMessageField: View {
	
	var placeholder: Text = Text("Say something...")
	@Binding var text: String
	var editingChanged: (Bool) -> () = { _ in }
	var commit: () -> () = {}
	
	var body: some View {
		ZStack(alignment: .leading) {
			
			if text.isEmpty {
				placeholder
					.opacity(0.5)
			}
			
			TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
		}
	}
	
}
