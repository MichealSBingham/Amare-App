//
//  Angle.swift
//  Angle
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation

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
    
    var id: String { name.rawValue }
    
    
}



enum AngleName: String, Codable{
    
    case Asc // Ascendant
    case MC // MC
    case Desc // Desc
    case IC // ic
    
}


struct CuspObject: Codable{
    
    let cusp_element: Element
    let cusp_sign: ZodiacSign
}
