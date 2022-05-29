//
//  NatalChart.swift
//  NatalChart
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation


public struct NatalChart: Codable, Equatable {
    
    
    public static func == (lhs: NatalChart, rhs: NatalChart) -> Bool {
        return lhs.angles == rhs.angles
        && lhs.aspects == rhs.aspects
        && lhs.birth_place == rhs.birth_place
        && lhs.planets == rhs.planets
        && lhs.houses == rhs.houses
    }
    
    
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
    
    /// The other person's (outer chart) angles (asc, mc, ic, etc)  if a synastry chart was added to this
    var synastryAngles: [Angle]?
   // var name: String?
    
   // public var id: String {name ?? "EmptyName"}, not needed ATM
    /*
    func planetsThatAspectWith(some planet: Planet) -> [PlanetName] {
        var planets: [PlanetName] = []
        
        for aspect in aspects ?? []{
            
            if (aspect.first.rawValue == planet.name.rawValue) || (aspect.second.rawValue == planet.name.rawValue) {
                
                
                if aspect.first.rawValue != planet.name.rawValue {
                    if let name = PlanetName(rawValue: aspect.first.rawValue){
                        planets.append(name)
                        }
                   
                } else {
                    if let name = PlanetName(rawValue: aspect.second.rawValue){
                        planets.append(name)
                        }
                }
            }
            
        }
        
        
        
        return planets
    }
    */
    
    
    func aspectsInvolving(some planet: Planet) -> [Aspect] {
        
        var aspects: [Aspect] = []
        
        for aspect in self.aspects {
            
            if aspect.type != .none{
                
                // the planet is involved in the aspect
                if aspect.first.rawValue == planet.name.rawValue || aspect.second.rawValue == planet.name.rawValue{
                    
                    aspects.append(aspect)
                }
            }
        }
        
        
        return aspects
    }
    /// Might be broken
    func bodiesThatAspectWith(some planet: Angle) -> [Body] {
        var planets: [Body] = []
        
        for aspect in aspects ?? []{
            
            if (aspect.first.rawValue == planet.name.rawValue) || (aspect.second.rawValue == planet.name.rawValue) {
                
                
                if aspect.first.rawValue != planet.name.rawValue {
                    if let name = Body(rawValue: aspect.first.rawValue){
                        planets.append(name)
                        }
                   
                } else {
                    if let name = Body(rawValue: aspect.second.rawValue){
                        planets.append(name)
                        }
                }
            }
            
        }
        
        
        
        return planets
    }
    
    /// Might be broken
    func bodiesThatAspectWith(some planet: Planet) -> [Body] {
        var planets: [Body] = []
        
        for aspect in aspects ?? []{
            
            if (aspect.first.rawValue == planet.name.rawValue) || (aspect.second.rawValue == planet.name.rawValue) {
                
                
                if aspect.first.rawValue != planet.name.rawValue {
                    if let name = Body(rawValue: aspect.first.rawValue){
                        planets.append(name)
                        }
                   
                } else {
                    if let name = Body(rawValue: aspect.second.rawValue){
                        planets.append(name)
                        }
                }
            }
            
        }
        
        
        
        return planets
    }

    func getPlanetsThisPlanetAspectsWithSynastry() -> [Planet]? {
        for aspect in synastryAspects ?? []{
            
        }
        
        return nil
    }
   
    
}
/// Used for grabbing specific planet
extension Array where Element == Planet {
    /// Returns the planet of an array of planets 
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



