//
//  IncomingFriendRequest.swift
//  Amare
//
//  Created by Micheal Bingham on 8/2/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct IncomingFriendRequest: Codable, Identifiable, Hashable {
	/// the UserID the request is `from`
	@DocumentID public var id: String?
	var status: FriendshipStatus
	var isNotable: Bool
	var name: String
	var profileImageURL: String
	var from: String
	var time: Timestamp
	
	var formattedTime: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a z"
		return formatter.string(from: time.dateValue())
	}
	
	
	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
			hasher.combine(status)
			hasher.combine(isNotable)
			hasher.combine(name)
			hasher.combine(profileImageURL)
			hasher.combine(from)
			hasher.combine(time)
		}
		
		static func == (lhs: IncomingFriendRequest, rhs: IncomingFriendRequest) -> Bool {
			return lhs.id == rhs.id &&
				lhs.status == rhs.status &&
				lhs.isNotable == rhs.isNotable &&
				lhs.name == rhs.name &&
				lhs.profileImageURL == rhs.profileImageURL &&
				lhs.from == rhs.from &&
				lhs.time == rhs.time
		}
}




extension IncomingFriendRequest {
	/*static let example = FriendRequest(status: .pending,
									   isNotable: false,
									   name: "Michael",
									   profileImageURL:  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
									   requestedBy: "u4uS1JxH2ZO8re6mchQUJ1q18Km2",
									   time: Timestamp(date: Date())) */
	
	
	static func random() -> IncomingFriendRequest {
			let accepted = Bool.random()
			let isNotable = Bool.random()
			let name = ["John", "Alice", "Michael", "Emily", "David", "Sarah"].randomElement() ?? ""
			let profileImageURL = URL.randomProfileImageURL()!.absoluteString
			let requestedBy = UUID().uuidString
			let time = Timestamp(date: Date.random())

		return IncomingFriendRequest(id: UUID().uuidString ,
							 status: FriendshipStatus.pending,
								 isNotable: isNotable,
								 name: name,
								 profileImageURL: profileImageURL,
								 from: requestedBy,
								 time: time)
		}
	
	func asDictionary() -> [String: Any] {
		   return [
			   "id": id ?? "",
			   "status": status.rawValue, // Assuming FriendshipStatus is an enum
			   "isNotable": isNotable,
			   "name": name,
			   "profileImageURL": profileImageURL,
			   "from": from,
			   "time": time // Assuming Timestamp is a type that Firestore can handle directly
			   // "formattedTime": formattedTime // This is derived from `time`, so it may not be necessary to include it in the dictionary
		   ]
	   }
}


extension IncomingFriendRequest {
	static func randomList(count: Int) -> [IncomingFriendRequest] {
		return (1...count).map { _ in IncomingFriendRequest.random() }
	}
}
