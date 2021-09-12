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
    var aspects: [Aspect]
    let birth_place: Place
    let birthday: String
    var houses: [House]
    var planets: [Planet]
    
    /// Aspects used in synastry between this chart and another chart.
    var synastryAspects: [Aspect]?
    /// The other person's (outer chart) planets if a synastry chart was added to this 
    var synastryPlanets: [Planet]?
   // var name: String?
    
   // public var id: String {name ?? "EmptyName"}, not needed ATM
   
    
}

extension Array where Element == Planet {
    func get(planet: PlanetName) -> Planet? {
        for planet_obj in self{
            if planet_obj.name == planet{
                return planet_obj
            }
        }
        return nil
    }
    
   

    
}

extension Array where Element == Angle {
    func get(planet: AngleName) -> Angle? {
        for planet_obj in self{
            if planet_obj.name == planet{
                return planet_obj
            }
        }
        return nil
    }
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



