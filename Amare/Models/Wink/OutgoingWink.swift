//
//  OutgoingWink.swift
//  Amare
//
//  Created by Micheal Bingham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

struct OutgoingWink: Codable, Identifiable, Hashable {
    /// the UserID the request is `from`
    @DocumentID public var id: String?
    
    


    var from: String
    //var to: String
    var time: Timestamp
    
    //TODO: Add a location property here to see where the user was when they sent the link , the same with incoming...
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a z"
        return formatter.string(from: time.dateValue())
    }
    
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            
            hasher.combine(from)
            hasher.combine(time)
            //hasher.combine(to)
        }
        
    static func == (lhs: OutgoingWink, rhs: OutgoingWink) -> Bool {
            return lhs.id == rhs.id &&
              
                lhs.from == rhs.from &&
                lhs.time == rhs.time
            
        }
    
    func asDictionary() -> [String: Any] {
           return [
               
               "from": from,
               "time": time // Assuming Timestamp is a type that Firestore can handle directly
               // "formattedTime": formattedTime // This is derived from `time`, so it may not be necessary to include it in the dictionary
           ]
       }
}

