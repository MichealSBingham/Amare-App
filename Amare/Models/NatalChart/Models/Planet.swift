//
//  Planet.swift
//  Planet
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation
import SwiftUI

struct Planet: Codable, Identifiable, Equatable, Hashable{
    
  
    
    /// Name of the planet
    let name: PlanetName
    /// Angle the planet is in its sign; example: Cancer 25 degrees. 25.0
    let angle: Double
    /// Element the sign is in, not the planet.
    let element: Element
    let onCusp: Bool
    /// Whether or not planet is moving in retrograde
    let retrograde: Bool
    //TODO: Set in database a placement interpretation
    var one_line_placement_interpretation: String? = "One line description of this sign."
    var longer_placement_interpretation: String? = "Something else that describes this placement."
    let sign: ZodiacSign
    
    var house: Int?  =  1
    
    /// A cusp object will contain the cusp element and cusp sign the object is on
    let cusp: CuspObject?
    
    /// Average speed planet is moving in degrees/day
    let speed: Double
    
    var id: String { "\(name.rawValue)\(sign.rawValue)\(angle)" }
    var iconName: String {name.rawValue}
    
    /// If we run synastry with person A and person B, this distinguishes A's planets from B's. So if B is the outer person on the bi-wheel chart, this property will be true for B's planets. 
    var forSynastry: Bool? = false
    
    /// This is not data that comes from the database; rather, WE set this variable so that we know what color to color `MainPlacementView`
    var _aspectThatExists: AspectType? = nil
    
  
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case angle
        case element
        case onCusp = "is_on_cusp"
        case retrograde = "is_retrograde"
        case sign
        case cusp = "almost"
        case speed
        case house
     
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
    
    
    static func ==(lhs: Planet, rhs: Planet) -> Bool {
        return lhs.id == rhs.id
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
    
    /// place in the solar system
    func number() -> Int {
        
        switch self {
        case .Sun:
            return 1
        case .Moon:
            return 4
        case .Mercury:
            return 2
        case .Venus:
            return 3
        case .Mars:
            return 5
        case .Jupiter:
            return 6
        case .Saturn:
            return 7
        case .Uranus:
            return 8
        case .Neptune:
            return 9
        case .Pluto:
            return 10
        case .Chiron:
            return 11
        case .NorthNode:
            return 12
        case .SouthNode:
            return 13 
        }
    }
    
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
    
    //TODO: Finish
    func houseRuler() -> HouseNameOrd? {
        
        switch self {
        case .Sun:
            return nil
        case .Moon:
            return .fourth
        case .Mercury:
            return nil
        case .Venus:
            return nil
        case .Mars:
            return nil
        case .Jupiter:
            return nil
        case .Saturn:
            return nil
        case .Uranus:
            return nil
        case .Neptune:
            return nil
        case .Pluto:
            return nil
        case .Chiron:
            return nil
        case .NorthNode:
            return nil
        case .SouthNode:
            return nil 
        }
    }
    
   
    /// Returns the 3Dimage for the planet
    func image_3D() ->  some View {
        
      
        
        return Image("ZodiacIcons/3D\(self.rawValue)")
            .resizable()
            .aspectRatio(contentMode: .fit)
                  
          
    }
}

extension Planet {
    
    static func random() -> Planet {
        let allPlanetNames = PlanetName.allCases
        let allElements = Element.allCases
        let allZodiacSigns = ZodiacSign.allCases
        
        let randomPlanetName = allPlanetNames.randomElement()!
        let randomAngle = Double.random(in: 0...30)
        let randomElement = allElements.randomElement()!
        let randomOnCusp = Bool.random()
        let randomRetrograde = Bool.random()
        let randomSign = allZodiacSigns.randomElement()!
        let randomSpeed = Double.random(in: 0.1...1.5)
        let randomHouse = Int.random(in: 1...12)
        
        let randomCusp: CuspObject? = /*Bool.random() ? CuspObject(element: randomElement, sign: randomSign) : */ nil
        
        return Planet(
            name: randomPlanetName,
            angle: randomAngle,
            element: randomElement,
            onCusp: randomOnCusp,
            retrograde: randomRetrograde,
            sign: randomSign,
            house: randomHouse, cusp: randomCusp,
            speed: randomSpeed
        )
    }
    
    static func randomArray(ofLength length: Int) -> [Planet] {
           return (0..<length).map { _ in random() }
       }
}
