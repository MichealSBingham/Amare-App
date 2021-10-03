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
    
    var id: String { "\(name.rawValue)\(sign.rawValue)\(angle)" }
    var iconName: String {name.rawValue}
    
    /// If we run synastry with person A and person B, this distinguishes A's planets from B's. So if B is the outer person on the bi-wheel chart, this property will be true for B's planets. 
    var forSynastry: Bool? = false
    
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
    
    /// Returns the image for the planet of given size, will autosize if it's a synastry planet or not
    func image(size: Double) ->  some View {
        
        
        var sizeToUse = size
        if self.forSynastry ?? false {
            // increase the size by two
            sizeToUse = size*1.5
        }
        
    
            
        
        return Image("ZodiacIcons/\(self.iconName)")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(sizeToUse*0.30), height: CGFloat(sizeToUse*0.30))
            .colorInvert()
    }
    
    func inWhatHouse(houses: [House]) -> House? {
        
        guard  let  body = Body(rawValue: self.name.rawValue)  else { return nil }
        for house in houses{
           // var body =
            if house.rulingBodies?.contains(body) ?? false{
                return house
            }
        }
        return nil
    }
    
}

enum PlanetName: String, Codable, CaseIterable {
    
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
    
    /// Returns the image for the planet
    func image() ->  some View {
        
      
        
        return Image("ZodiacIcons/\(self.rawValue)")
            .resizable()
            .aspectRatio(contentMode: .fit)
                  
          
    }
   
}
