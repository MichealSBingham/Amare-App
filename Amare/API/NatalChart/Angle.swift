//
//  Angle.swift
//  Angle
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation

/// One of 4 angles, Asc, Desc, Midheaven, and IC.
struct Angle{
    
    let name: AngleName
    let element: Element
    let onCusp: Bool
    let sign: ZodiacSign
    let cuspElement: Element?
    let cuspSign: ZodiacSign?
    ///  In degrees [int ] 
    let angle: Double
    
}

enum AngleName{
    
    case ascendant // Ascendant
    case midheaven // MC
    case descendant // Desc
    case imumCoeli // ic
    
}
