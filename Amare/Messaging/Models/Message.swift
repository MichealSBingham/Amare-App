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

public struct Message: Codable, Equatable, Hashable, Identifiable, Comparable {
	@DocumentID public var id: String?
	
	// The id of the thread this message belongs to
	var thread: String?
	
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
	
	/// Whether or not  the current signed in user has read the message, but don't use this in test mode
	var hasRead: Bool {
		
		return readBy.contains(where: { $0.id == Auth.auth().currentUser?.uid })
	}
	
	var outgoing: Bool {
		guard let id = Auth.auth().currentUser?.uid else { return false }
		return sentBy.id == id
	}
	/// Whether or not the message is the most recent message in the thread or not 
	var lastMessage: Bool = false
	
	
	public static func == (lhs: Message, rhs: Message) -> Bool {
		return lhs.id == rhs.id
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	
	//TODO: function for reading message
	public func read() {
		
	}
	
	public static func < (lhs: Message, rhs: Message) -> Bool {
			lhs.sentAt < rhs.sentAt
		}
	
	///Adds the message to the thread, or in other words, sends a message to a particular user/group chat
	func add()  {
		
	}
	
	/// Generates a random message. Only useful for 2-way conversations though.
	static func random(with me: AmareUser, and them: AmareUser, on thread: String) -> Message?{
	
		

	
		
		
	
		
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
		
		return Message(id: UUID().uuidString, thread: thread, text: text, sentBy: sent_by, sentAt: dateSent, readBy: readBy, ignoredBy: [], tooBusyToReply: [], readWhen: dateRead, type: type, lastMessage: false)
		
		
		
		

		
		
		
	}
	
	static func randomTwoWayConservation(with me: AmareUser, and them: AmareUser, number : Int = 20 , on thread: String) -> [Message]{
	
		
		var messages: [Message] = []
		
		for _ in 1...number {
			messages.append(Message.random(with: me, and: them, on: thread)!)
		}
		messages.sort()
		return messages
	}
	
	
}
