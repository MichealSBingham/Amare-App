//
//  Angle.swift
//  Angle
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation
import SwiftUI

/// One of 4 angles, Asc, Desc, Midheaven, and IC.
struct Angle: Codable, Identifiable{
    
    /// The name of the angle; i.e. Asc ("ascendant"),  MC ("midheaven") , etc
    let name: AngleName
    
    /// One of the 4 elements.
    let element: Element
    
    /// Whether or not the sign is on the cusp. Default orb cusp is set at 3 degrees,.
    let is_on_cusp: Bool
    
    /// Zodiac sign this angle is in
    let sign: ZodiacSign
    
    /// in degrees
    let angle: Double
    
    /// A cusp object will contain the cusp element and cusp sign the object is on
    let almost: CuspObject?
    
    /// If we run synastry with person A and person B, this distinguishes A's planets from B's. So if B is the outer person on the bi-wheel chart, this property will be true for B's planets
    var forSynastry: Bool? = false
    
    var id: String { "\(name.rawValue)\(sign.rawValue)\(angle)" }
    var iconName: String { name.rawValue }
    
    /// Will return the symbol of the planet
    /// The small version is just used so that it returns smaller characters if we use the smaller natal chart frame (like in the person pop up view_
    func image(smallVersion: Bool? = false) ->  some View {
        
        var size: CGFloat = 10
        
        
        var text = ""
            
          
            if self.forSynastry ?? false {
                // increase the size by two
               size = 15
                
                
            }
        
        if smallVersion ?? false {
            
            size = size / 2
        }
        
        
        switch self.name {
        case .asc:
            text = "ASC"
        case .mc:
            text = "MC"
        case .desc:
            text = "DESC"
        case .ic:
            text = "IC"
        default:
            text = ""
        }
                
            
        
        return Text(text)
            .font(.system(size: size))
           // .frame(width: CGFloat(sizeToUse*0.30), height: CGFloat(sizeToUse*0.30))
            
            
            /*
            return Image("ZodiacIcons/\(self.iconName)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(sizeToUse*0.30), height: CGFloat(sizeToUse*0.30))
                .colorInvert()
        */
        
                
    }
    
    func smallerImage() -> some View {
        return self.image(smallVersion: true)
    }
}



enum AngleName: String, Codable, CaseIterable{
    
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
        }
    }
    
    
    /// Will return the symbol of the planet
    /// The small version is just used so that it returns smaller characters if we use the smaller natal chart frame (like in the person pop up view_
    func image(smallVersion: Bool? = false) ->  some View {
        
        var size: CGFloat = 15
        
        
        var text = ""
            
          
        
        if smallVersion ?? false {
            
            size = size / 2
        }
        
        
        switch self {
        case .asc:
            text = "ASC"
        case .mc:
            text = "MC"
        case .desc:
            text = "DESC"
        case .ic:
            text = "IC"
        default:
            text = ""
        }
                
            
        
        return Text(text)
            .font(.system(size: size))
            .bold()
            .colorInvert()
           // .frame(width: CGFloat(sizeToUse*0.30), height: CGFloat(sizeToUse*0.30))
            
            
            /*
            return Image("ZodiacIcons/\(self.iconName)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(sizeToUse*0.30), height: CGFloat(sizeToUse*0.30))
                .colorInvert()
        */
        
                
    }
    
    func smallerImage() -> some View {
        return self.image(smallVersion: true)
    }
    
}


struct CuspObject: Codable{
    
    let cusp_element: Element
    let cusp_sign: ZodiacSign
}
