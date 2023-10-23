//
//  DiscoveryTokenDocument.swift
//  Amare
//
//  Created by Micheal Bingham on 10/13/23.
//



import FirebaseFirestore
import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

import FirebaseFirestore 
struct DiscoveryTokenDocument: Codable {
    @DocumentID var id: String?  // Using @DocumentID for automatic id mapping
    var dateCreated: Timestamp?  // Using Firestore's Timestamp type
    var token: Data?
    var deviceSupportsNI: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated
        case token
        case deviceSupportsNI
    }

    // Your initializer remains the same
   /* init(userId: String, token: Data?, deviceSupport: Bool) {
        self.id = userId
        self.dateCreated = Timestamp(date: Date())
        self.token = token
        self.deviceSupportsNI = deviceSupport
    } */
}
