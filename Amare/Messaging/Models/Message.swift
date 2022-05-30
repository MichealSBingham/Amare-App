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
	
	
	static func random() -> Message?{
		return nil 
	}
}
