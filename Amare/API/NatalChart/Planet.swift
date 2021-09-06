//
//  Planet.swift
//  Planet
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation
import SwiftUI

struct Planet: Codable, Identifiable{
    
  
    
    /// Name of the planet
    let name: PlanetName
    /// Angle the planet is in its sign; example: Cancer 25 degrees. 25.0
    let angle: Double
    /// Element the sign is in, not the planet.
    let element: Element
    let onCusp: Bool
    /// Whether or not planet is moving in retrograde
    let retrograde: Bool
    
    
    let sign: ZodiacSign
    
    /// A cusp object will contain the cusp element and cusp sign the object is on
    let cusp: CuspObject?
    
    /// Average speed planet is moving in degrees/day
    let speed: Double
    
    var id: String { name.rawValue }
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case angle
        case element
        case onCusp = "is_on_cusp"
        case retrograde = "is_retrograde"
        case sign
        case cusp = "almost"
        case speed
     
     
    }
    
    func image() ->  Image {
        
        return Image("ZodiacIcons/\(self.id)")
                
    }
    
    
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
    case NorthNode = "North Node"
    case SouthNode = "South Node"
    
   
}
