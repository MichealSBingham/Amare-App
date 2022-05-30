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

public struct MessageThread: Codable, Equatable, Hashable, Identifiable{
	
	@DocumentID public var id: String?// = UUID().uuidString
	var createdAt: Date = Date()
	
	var members: [AmareUser] = []
	
	var lastModified: Date
	
	var type: MessageType
	
	//MARK: Things to show in Thread View
	
	// If a group, will be the thumbnail image group sets, otherwise should be the other url image
	var thumbnailURL: String?
	
	/// Will be the group name or the other person
	var name: String
	
	var lastMessage: Message?
	
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
	
}

enum MessageType: String, Codable{
	case privateGroup
	case publicGroup
	case twoWay
}
