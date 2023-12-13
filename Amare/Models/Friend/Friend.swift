//
//  Friend.swift
//  Amare
//
//  Created by Micheal Bingham on 10/9/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

import FirebaseFirestore 

struct Friend: Codable, Identifiable, Hashable {
    @DocumentID public var id: String?
    var isNotable: Bool
    var name: String
    var profileImageURL: String
    var friends_since: Timestamp // Make sure Timestamp conforms to Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case isNotable
        case name
        case profileImageURL = "profile_image_url"
        case friends_since = "friends_since"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isNotable)
        hasher.combine(name)
        hasher.combine(profileImageURL)
        hasher.combine(friends_since)
    }
    
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.id == rhs.id &&
            lhs.isNotable == rhs.isNotable &&
            lhs.name == rhs.name &&
            lhs.profileImageURL == rhs.profileImageURL &&
            lhs.friends_since == rhs.friends_since
    }
}




