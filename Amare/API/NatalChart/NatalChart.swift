//
//  NatalChart.swift
//  NatalChart
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation


public struct NatalChart: Codable {
    
    
    var angles: [Angle]
    //let aspects: [Aspect] =
    var birth_place: Place
    var birthday: String
   // let houses: [House]? = nil
 //   var planets: [Planet]
   // var name: String?
    //let sex: Sex?; not included currently 
    
   // public var id: String {name ?? "EmptyName"}
   
    
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
            return "non_binary"
        }
    }

}


