//
//  FriendshipStatus.swift
//  Amare
//
//  Created by Micheal Bingham on 7/30/23.
//

import Foundation


//Firestore Model , this is or firestore ONLY . NOT for reading the friendship status that's dervied from it. i.e
enum FriendshipStatus: String, Codable  {
	case friends = "friends"
	case notFriends = "not_friends"
	case pending = "pending"
	
	/// This is default, means the data is loading
	case none = "none" // = "none"

}

enum UserFriendshipStatus: String, Codable{
	case friends
	/// no friend request is from either user
	case notFriends
	/// data is probably still loading
	case unknown
	/// `you` requested the user, awaiting their response
	case requested
	/// awaiting `your` response
	case awaiting
	
}




extension UserFriendshipStatus {
	var imageName: String {
		switch self {
		case .unknown:
			return "person.fill.xmark"
		case .friends:
			return "person.fill.checkmark"
		case .notFriends:
			return "person.fill.badge.plus" // this is so th
		case .requested:
			return "rectangle.portrait.and.arrow.forward.fill"
		case .awaiting:
			return "mail.fill" 
		
		}
	}
}
