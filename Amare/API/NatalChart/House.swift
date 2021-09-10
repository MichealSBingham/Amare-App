//
//  House.swift
//  Amare
//
//  Created by Micheal Bingham on 9/10/21.
//

import Foundation


struct House: Codable, Identifiable {
    
    /// The angle in the sign the house begins in
    let angle: Double
    
    let condition: HouseCondition
    
    /// The ordinality of the house, etc 1, 2, 3, ..., 12. 'name' in database.
    let ordinality: Int
    
    /// The sign the house begins in
    let sign: ZodiacSign
    
    /// The size of the  house in degrees
    let size: Double
    
    /// The ruling planets or angles. An array of planets/angles this house contains.
    let rulingBodies: [Body]?
    
    enum CodingKeys: String, CodingKey {
        
        case angle
        case condition
        case ordinality = "name"
        case sign
        case size
        case rulingBodies = "contains"
        
     
     
    }
    
    var id: Int { ordinality }
}

enum HouseCondition: String, Codable{
    
    case Succedent
    case Angular
    case Cadent
}
