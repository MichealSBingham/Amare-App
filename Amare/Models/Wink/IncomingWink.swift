//
//  IncomingWink.swift
//  Amare
//
//  Created by Micheal Bingham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct IncomingWink: Codable, Identifiable, Hashable {
    /// the UserID the request is `from`
    @DocumentID public var id: String?
    
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
            hasher.combine(isNotable)
            hasher.combine(name)
            hasher.combine(profileImageURL)
            hasher.combine(from)
            hasher.combine(time)
        }
        
        static func == (lhs: IncomingWink, rhs: IncomingWink) -> Bool {
            return lhs.id == rhs.id &&
             
                lhs.isNotable == rhs.isNotable &&
                lhs.name == rhs.name &&
                lhs.profileImageURL == rhs.profileImageURL &&
                lhs.from == rhs.from &&
                lhs.time == rhs.time
        }
}




extension IncomingWink {
    
    
    func asDictionary() -> [String: Any] {
           return [
               "id": id ?? "",
               "isNotable": isNotable,
               "name": name,
               "profileImageURL": profileImageURL,
               "from": from,
               "time": time // Assuming Timestamp is a type that Firestore can handle directly
               // "formattedTime": formattedTime // This is derived from `time`, so it may not be necessary to include it in the dictionary
           ]
       }
}


