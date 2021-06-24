//
//  UserData.swift
//  Love
//
//  Created by Micheal Bingham on 6/23/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

/// Helper class we're using to store and read data from our backend. All user data properties read from database are here.
public struct UserData: Codable{
    
    @DocumentID var id: String?
    
    let name: String?
    let birthday: Birthday?
    let hometown: Place?
    let residence: Place?
    
    
    
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case birthday
        case hometown
        case residence 
    }
    
}


struct Birthday: Codable{
    
    var timestamp: Timestamp?
    var month: String?
    var day: Int?
    var year: Int?
}



struct Place: Codable  {
    
    var latitude: Double?
    var longitude: Double?
    
    var city: String?
    var state: String?
    var country: String?
    
    var geohash: String?
    
    
    
}

