//
//  NatalChart.swift
//  NatalChart
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation


public struct NatalChart: Codable {
    
    /// An array of the 4 angles (Midheaven, Ascendant, Descendant, IC)
    var angles: [Angle]
    //let aspects: [Aspect] =
    var birth_place: Place
    var birthday: String
   // let houses: [House]? = nil
    var planets: [Planet]
   // var name: String?
    
   // public var id: String {name ?? "EmptyName"}, not needed ATM
   
    
}


enum Sex: String, Codable  {
    case male
    case female
    case transfemale
    case transmale
    case non_binary
    
    func string() -> String {
        
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .transfemale:
            return "transfemale"
        case .transmale:
            return  "transmale"
        case .non_binary:
            return "non binary"
        }
    }

}


