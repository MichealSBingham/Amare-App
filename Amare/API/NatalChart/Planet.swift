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
    
    /// Returns the description of the planet and how it relates to astrology.
    func description() -> String {
        
        switch self {
        case .Sun:
            return "The Sun gives insight to your core personality, expression and true self."
        case .Moon:
            return "The Moon gives insight to your emotional life."
        case .Mercury:
            return "Description not ready."
        case .Venus:
            return "Description not ready."
        case .Mars:
            return "Description not ready."
        case .Jupiter:
            return "Description not ready."
        case .Saturn:
            return "Description not ready."
        case .Uranus:
            return "Description not ready."
        case .Neptune:
            return "Description not ready."
        case .Pluto:
            return "Description not ready."
        case .Chiron:
            return "Description not ready."
        case .NorthNode:
            return "Description not ready."
        case .SouthNode:
            return "Description not ready."
        }
       
    }
    
    func longerDescription() -> String  {
        
        
        switch self {
        case .Sun:
            return "The Sun gives insight to your core personality, expression and true self."
        case .Moon:
            return "The *sign* it is in tells how you *show*, *process*, *feel*, and *recieve* **emotions**."
        case .Mercury:
            return "Description not ready."
        case .Venus:
            return "Description not ready."
        case .Mars:
            return "Description not ready."
        case .Jupiter:
            return "Description not ready."
        case .Saturn:
            return "Description not ready."
        case .Uranus:
            return "Description not ready."
        case .Neptune:
            return "Description not ready."
        case .Pluto:
            return "Description not ready."
        case .Chiron:
            return "Description not ready."
        case .NorthNode:
            return "Description not ready."
        case .SouthNode:
            return "Description not ready."
        }
    }
    
    /// Returns the image for the planet
    func image() ->  some View {
        
      
        
        return Image("ZodiacIcons/\(self.rawValue)")
            .resizable()
            .aspectRatio(contentMode: .fit)
                  
          
    }
    
    //TODO: FINSIH
    /// Keywords that this planet governs over. Example: The moon rules over Emotions, and also feelings, etc so it will return ["Emotions", "Feelings"]
    func keywords() -> [String] {
        
        switch self {
        case .Sun:
            return ["Identity", "Self", "Expression"]
        case .Moon:
            return ["Emotions", "Feelings"]
        case .Mercury:
            return ["Not Complete"]
        case .Venus:
            return ["Not Complete"]
        case .Mars:
            return ["Not Complete"]
        case .Jupiter:
            return ["Not Complete"]
        case .Saturn:
            return ["Not Complete"]
        case .Uranus:
            return ["Not Complete"]
        case .Neptune:
            return ["Not Complete"]
        case .Pluto:
            return ["Not Complete"]
        case .Chiron:
            return ["Not Complete"]
        case .NorthNode:
            return ["Not Complete"]
        case .SouthNode:
            return ["Not Complete"]
        }
    }
    
    
   
    /// Returns the 3Dimage for the planet
    func image_3D() ->  some View {
        
      
        
        return Image("ZodiacIcons/3D\(self.rawValue)")
            .resizable()
            .aspectRatio(contentMode: .fit)
                  
          
    }
}
