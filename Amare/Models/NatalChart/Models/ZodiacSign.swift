//
//  ZodiacSign.swift
//  ZodiacSign
//
//  Created by Micheal Bingham on 8/21/21.
//

import Foundation
import SwiftUI

///  a list of zodiac signs in order from Aries
let ZODIAC_SIGNS: [ZodiacSign] = [ .Aries, .Taurus, .Gemini, .Cancer, .Leo, .Virgo, .Libra, .Scorpio, .Sagittarius, .Capricorn, .Aquarius, .Pisces]

enum ZodiacSign: String, Codable, CaseIterable{
    
    case Aries
    case Taurus
    case Pisces
    case Aquarius
    case Capricorn
    case Sagittarius
    case Scorpio
    case Libra
    case Virgo
    case Leo
    case Cancer
    case Gemini

    
    
    /// Will return the symbol of the planet
    func image() ->  Image {
        
        return Image("ZodiacIcons/\(self)")
            
                
    }
    
    /// Returns the angle(degree) the zodiac sign begins at, relative to Aries being 0 degrees. 
    func beginsAt() -> Double {
        if let index = ZODIAC_SIGNS.firstIndex(of: self) {
            return Double(index*30)
        }
        return -1
    }
}
