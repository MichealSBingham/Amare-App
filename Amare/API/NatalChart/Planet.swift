//
//  Planet.swift
//  Planet
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation


struct Planet{
     
    let name: PlanetName
    let angle: Double
    let element: Element
    let onCusp: Bool
    let retrograde: Bool
    let sign: ZodiacSign
    let cuspSign: ZodiacSign?
    let cuspElement: Element?
    let speed: Double /// deg/day 
    
}

enum PlanetName {
    
    case sun
    case moon
    case mercury
    case venus
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    case pluto
    case chiron
    case north_node
    case south_node
}
