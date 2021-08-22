//
//  Planet.swift
//  Planet
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation


struct Planet: Codable, Identifiable{
    
  
    
    /// Name of the planet
    let name: PlanetName
    /// Angle the planet is in its sign; example: Cancer 25 degrees. 25.0
    let angle: Double
    /// Element the sign is in, not the planet.
    let element: Element
    let is_on_cusp: Bool
    /// Whether or not planet is moving in retrograde
    let is_retrograde: Bool
    
    
    let sign: ZodiacSign
    
    /// A cusp object will contain the cusp element and cusp sign the object is on
    let almost: CuspObject?
    
    /// Average speed planet is moving in degrees/day
    let speed: Double
    
    var id: String { name.rawValue }
    
    
}

enum PlanetName: String, Codable {
    
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
    case North_Node
    case South_Node
}
