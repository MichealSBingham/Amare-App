//
//  Message.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import LoremSwiftum

public struct Message: Codable, Equatable, Hashable, Identifiable {
	@DocumentID public var id: String?
	
	//MARK: - Message contents
	///Text of the message
	 var text: String
	
	var sentBy: AmareUser
	
	var sentAt: Date = Date()
	
	//TODO: Monetize hiding status
	
	var readBy: [AmareUser] = []
	var ignoredBy: [AmareUser] = []
	// these are the users that probably haven't replied to the message because they're busy
	var tooBusyToReply: [AmareUser] = []
	
	var readWhen: Date? 
	var type: MessageType
	
	/// Whether or not the message is the most recent message in the thread or not 
	var lastMessage: Bool = false
	
	
	public static func == (lhs: Message, rhs: Message) -> Bool {
		return lhs.id == rhs.id
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	
	/// Generates a random message. Only useful for 2-way conversations though.
	static func random(with me: AmareUser, and them: AmareUser) -> Message?{
	
		

	
		
		
	
		
		let type = MessageType.twoWay
		
		let text = Lorem.sentences(1...10)
		
		let sent_by = [me, them].randomElement()!
		
		
		var now = Date()
		var past = now.getDateFor(days: -1)!
		
		var dateSent  = Date.random(in: past ..< now)
		var dateRead = Date()
		
		var readBy: [AmareUser] = []
		
		
		
		dateRead = Date.random(in: dateSent ..< now )
		
		// If I sent the message
		if sent_by.id == me.id {
			//d
			
			readBy.append(me)
			
			
		} else {
			
			readBy.append(them)
			
		}
		
		return Message(id: UUID().uuidString, text: text, sentBy: sent_by, sentAt: dateSent, readBy: readBy, ignoredBy: [], tooBusyToReply: [], readWhen: dateRead, type: type, lastMessage: false)
		
		
		
		

		
		
		
		return nil 
	}
	
	static func randomTwoWayConservation(with me: AmareUser, and them: AmareUser, number : Int = 20 ) -> [Message]{
	
		
		var messages: [Message] = []
		
		for _ in 1...number {
			messages.append(Message.random(with: me, and: them)!)
		}
		return messages
	}
	
	
}
