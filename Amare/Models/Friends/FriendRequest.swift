//
//  FriendRequest.swift
//  Amare
//
//  Created by Micheal Bingham on 7/12/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct FriendRequest: Codable, Identifiable {
    @DocumentID public var id: String?
    var accepted: Bool
    var isNotable: Bool
    var name: String
    var profileImageURL: String
    var requestedBy: String
    var time: Timestamp
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a z"
        return formatter.string(from: time.dateValue())
    }
}

extension FriendRequest {
    static let example = FriendRequest(accepted: false,
                                       isNotable: false,
                                       name: "Michael",
                                       profileImageURL:  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
                                       requestedBy: "u4uS1JxH2ZO8re6mchQUJ1q18Km2",
                                       time: Timestamp(date: Date()))
}
