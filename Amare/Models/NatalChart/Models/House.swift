//
//  House.swift
//  Amare
//
//  Created by Micheal Bingham on 9/10/21.
//

import Foundation


struct House: Codable, Identifiable, Equatable {
    
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
    
    /// Returns '1st', '2nd' , '3rd', etc..
    func name() -> String? {
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let house = formatter.string(from: NSNumber(value: self.ordinality))
        return house
    }
}

enum HouseCondition: String, Codable{
    
    case Succedent
    case Angular
    case Cadent
}

enum HouseNameOrd: String, CaseIterable{
    case first = "1st"
    case second = "2nd"
    case third = "3rd"
    case fourth = "4th"
    case fifth = "5th"
    case sixth = "6th"
    case seventh = "7th"
    case eight = "8th"
    case ninth = "9th"
    case tenth = "10th"
    case eleventh = "11th"
    case twelth = "12th"
}

extension Int {
    func toHouseNameOrd() -> HouseNameOrd? {
        switch self {
        case 1: return .first
        case 2: return .second
        case 3: return .third
        case 4: return .fourth
        case 5: return .fifth
        case 6: return .sixth
        case 7: return .seventh
        case 8: return .eight
        case 9: return .ninth
        case 10: return .tenth
        case 11: return .eleventh
        case 12: return .twelth
        default:
            return nil
        }
    }
}
