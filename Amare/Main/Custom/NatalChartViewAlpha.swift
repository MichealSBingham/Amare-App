//
//  NatalChartViewAlpha.swift
//  NatalChartViewAlpha
//
//  Created by Micheal Bingham on 8/22/21.
//

import SwiftUI

struct NatalChartViewAlpha: View {
    
    @State var infoDisplayed: Information = .Planets
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    func NatalChartAlphaView(account: Account) -> some View  {
        
        
      
       // @State var infoShownText: String = "Planets"
        
        return ZStack{
            
            VStack{
                
                Group{
                    
                    /*
                    Text(infoDisplayed.rawValue).padding().onTapGesture {
                        
                        infoDisplayed = infoDisplayed.toggle()
                        //   infoShownText = infoDisplayed.rawValue
                        print("On tap the info shown is \(infoDisplayed.rawValue)")
                    }
                    
                    */
                    // Planets
                    ForEach(account.data?.natal_chart?.planets ?? []){ planet in
                        
        //    Text("\(planet.name.rawValue)\t\t\(planet.sign.rawValue)\t\t \(planet.angle.dms)\t\t\(planet.element.rawValue)")
                        
                        HStack{
                            
                            Spacer()
                            Text(planet.name.rawValue)
                            Spacer()
                            Text(planet.sign.rawValue)
                            Spacer()
                            Text(planet.angle.dms)
                            Spacer()
                            Text(planet.element.rawValue)
                            Spacer()
                        }
                        Spacer()
                        
                    }
                    
                }.opacity(infoDisplayed == .Planets ? 1 : 0 )
                
               
                
                
                
                
                
                
            }
            
            
            
            
        }
        
        
     
    }
}

struct NatalChartViewAlpha_Previews: PreviewProvider {
    static var previews: some View {
        NatalChartViewAlpha()
    }
}

enum Information: String{
    case Planets
    case Angles
    
    mutating func toggle() -> Information {
      
        switch self {
        case .Planets:
            return .Angles
        case .Angles:
            return .Planets
        }
    }
    
    func string() -> String{
        if self == .Planets {return "Planets"}
        else {
            return "Angles"
        }
        
    }
}

enum PlanetInformation: String{
    case basic
    case detailed
    
    mutating func toggle() -> PlanetInformation {
      
        switch self {
        case .basic:
            return .detailed
        case .detailed:
            return .basic
        }
    }
    
    func string() -> String{
        if self == .basic {return "basic"}
        else {
            return "detailed"
        }
        
    }
}

