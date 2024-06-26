//
//  Dice.swift
//  Amare
//
//  Created by Micheal Bingham on 12/2/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

import SwiftUI
import FirebaseFirestore
import MapKit 

struct Dice: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var name: String
    var profileImageUrl: String?
    var images: [String]
    var sex: Sex
    var orientation: [Sex]
    var reasonsForUse: [ReasonsForUse]
    var isForDating: Bool
    var isForFriends: Bool
    var location: GeoPoint
    var geohash: String
    var date: Date
    
    var type: DiceType? = DiceType.none
}

enum DiceType: String, Codable{
    case dating
    case friends
    case doNotShow
    
    case none
}
