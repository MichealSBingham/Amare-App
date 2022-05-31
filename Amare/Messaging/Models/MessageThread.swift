//
//  MessageThread.swift
//  Amare
//
//  Created by Micheal Bingham on 5/29/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

public struct MessageThread: Codable, Equatable, Hashable, Identifiable, Comparable{
	
	@DocumentID public var id: String?// = UUID().uuidString
	var createdAt: Date = Date()
	
	var members: [AmareUser] = []
	
	var lastModified: Date
	
	var type: MessageType
	
	//MARK: Things to show in Thread View
	
	// If a group, will be the thumbnail image group sets, otherwise should be the other url image
	var thumbnailURL: String?
	
	/// Will be the group name.
	var name: String?
	
	var lastMessage: Message?
	
	/// If a two-way chat, this will return the user that is *Not* the current signed in user
	var otherUser: AmareUser? {
		
		guard type == .twoWay else { return nil }
		
		guard let me = Auth.auth().currentUser?.uid else { return nil }
		
		return members.first(where: {$0.id == me})
	}
	
	
	
	
	
	enum CodingKeys: String, CodingKey {
		case createdAt
		case members
		case lastModified
		case type
		case thumbnailURL
		case name
		case lastMessage
	}
	

	public static func == (lhs: MessageThread, rhs: MessageThread) -> Bool {
		return lhs.id == rhs.id 
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	public static func <(lhs: MessageThread, rhs: MessageThread) -> Bool {
			lhs.lastModified < rhs.lastModified
		}
	
	static func randomThread(with me: AmareUser = AmareUser.random(), and them: AmareUser = AmareUser.random()) -> MessageThread {
		
		var threadID = UUID().uuidString
		var createdDate = Date.random(in: Date().dateFor(years: -1) ..< Date().getDateFor(days: -3)!)
		var members = [me, them]
		
		var thumbnail = them.profile_image_url
		var name = them.name!
		
		var lastMessage = Message.random(with: me, and: them, on: threadID)
		
		var lastModifiedDate = lastMessage!.readWhen ?? lastMessage!.sentAt//Date.random(in: createdDate ..< Date())
		
		
		return MessageThread(id: threadID, createdAt: createdDate, members: members, lastModified: lastModifiedDate, type: .twoWay, thumbnailURL: thumbnail, name: name, lastMessage: lastMessage)
	}
	
}

enum MessageType: String, Codable{
	case privateGroup
	case publicGroup
	case twoWay
}
