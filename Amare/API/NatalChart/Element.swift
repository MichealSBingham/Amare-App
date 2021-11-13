//
//  Element.swift
//  Element
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation
import SwiftUI

enum Element: String, Codable, CaseIterable{
    case water = "Water"
    case earth = "Earth"
    case fire = "Fire"
    case air = "Air"
    
    /// Returns the image of the elemtn 
    func image() -> Image {
       var iamgename =  self.rawValue.lowercased()
        return Image("ZodiacIcons/\(iamgename)")
    }
    
    
}
