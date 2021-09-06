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

enum ZodiacSign: String, Codable{
    
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

    
    
    /// Will return the symbol of the sign
    func image() ->  some View {
        
        switch self{
        
        case .Aries:
            return Text("A")
        case .Taurus:
            return Text("T")
        case .Pisces:
            return Text("P")
        case .Aquarius:
            return Text("Aq")
        case .Capricorn:
            return Text("Cp")
        case .Sagittarius:
            return Text("Sg")
        case .Scorpio:
            return Text("Sc")
        case .Libra:
            return Text("Lb")
        case .Virgo:
            return Text("V")
        case .Leo:
            return Text("L")
        case .Cancer:
            return Text("C")
        case .Gemini:
            return Text("G")
        }
    }
}
