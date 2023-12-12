//
//  Synastry.swift
//  Amare
//
//  Created by Micheal Bingham on 12/12/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI
import FirebaseFirestore

/// Represents a synastry between Person A and person B (id). Stored in /users/{userA}/insights
struct Synastry: Codable, Identifiable {
    @DocumentID public var id: String? //person B
    var personA: String
    var score: Double?
    var summary: String
    var aspects: [Aspect]
    
    enum CodingKeys: String, CodingKey {
        case id
        case personA
        case score
        case summary
        case aspects
    }
    
}
