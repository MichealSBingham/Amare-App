//
//  Aspect.swift
//  Aspect
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation
import SwiftUI


struct Aspect: Codable, Identifiable {
    
    /// Name of the aspect etc "Jupiter Asc"
    let name: String
    
    /// The first planet in the aspect
    let first: Body
    /// The second planet in the aspect
    let second: Body
    
    let isMutual: Bool
    ///  whether or not planets are moving togeher
    let mutualMovement: Bool
    
    /// Orb of the aspect in degrees
    let orb: Double
    
    /// Type of the aspect 
    let type: AspectType 
    
    var id: (String) { name }
    
    
    
    
}


enum AspectType: String, Codable, CaseIterable, Identifiable{
    
    case none = "NO ASPECT"
    case conjunction = "CONJUNCTION"
    case sextile =  "SEXTILE"
    case square = "SQUARE"
    case trine =  "TRINE"
    case opposition =  "OPPOSITION"
    case semisextile =  "SEMISEXTILE"
    case semiquintile = "SEMIQUINTILE"
    case semisquare = "SEMISQUARE"
    case quintile =  "QUINTILE"
    case sesquiquintile =  "SESQUIQUINTILE"
    case sesquisquare =  "SESQUISQUARE"
    case biquintile =  "BIQUINTILE"
    case quincunx =  "QUINCUNX"
    case all
    case nothing
    
    var id: String { self.rawValue }
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(self.toString()) }
    
    static func options() -> [AspectType]{
        var opt = AspectType.allCases
         opt.removeAll(where: {$0 == .none})
        return opt 
    }
    
    func toString() -> String{
        
        switch self {
        case .quincunx:
            return "Quincunxes"
        case .none:
            return "None"
        case .nothing:
            return "None"
        case .all:
            return "All"
        default:
            return "\(self.rawValue.capitalized)s"
        }
    }
    

}

/// Either an angle or a planet 
enum Body: String, Codable {
    
    case Sun
    case Moon
    case Mercury
    case Venus
    case Mars
    case Jupiter
    case Saturn
    case Uranus
    case Neptune
    case Pluto
    case Chiron
    case NorthNode = "North Node"
    case SouthNode = "South Node"
    
    case asc = "Asc" // Ascendant
    case mc = "MC" // MC
    case desc = "Desc" // Desc
    case ic = "IC" // ic
    
    func string() -> String  {
        
        switch self {
        case .asc:
            return "Ascendant"
        case .mc:
            return "Midheaven"
        case .desc:
            return "Descendant"
        case .ic:
            return "Imum Coeli"
        default:
            return self.rawValue
        }
    }

    
   
}
