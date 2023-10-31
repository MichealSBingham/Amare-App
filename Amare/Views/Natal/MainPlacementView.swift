//
//  MainPlacementView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/28/23.
//

import SwiftUI




/// To be used on the person popup, shows the  main placements and colors them
struct MainPlacementView: View {
    
    /// Planet Name
     var planetName: PlanetName?
    var sign: ZodiacSign?
    
   
    
    var body: some View {
        
        
            
            HStack{
                
                
                
                (planetName ?? PlanetName.allCases.randomElement()!).image()
                    .animation(.easeInOut, value: planetName)
                    .conditionalColorInvert()
                
                    
                
                (sign ?? ZodiacSign.allCases.randomElement()!).image()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                        .animation(.easeInOut, value: planetName)
                        .conditionalColorInvert()
                        
                        
                
                
                
            }
        

        
        
        
        
    }
}
// Angle version of the above

struct MainPlacementView_Angle: View {
    
    
    var angle: Angle?
    
    var color: Color? = .white
    
    var size: CGFloat = 10
    
    /// Set to true only if you don't want the aspect to be colored using the color convention we use for showing the intensity of the placement.
    var colorless: Bool? = false
    
    var body: some View {
        
        Button {
            
            NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: angle)
        } label: {
            HStack{
                
                
                
                (angle?.name ?? AngleName.allCases.randomElement()!).image()
                    .colorInvert()
                    .colorMultiply(colorless == false ? color! : .white)
                
                 //   .frame(width: 10, height: 10)
                    
                
                (angle?.sign ?? ZodiacSign.allCases.randomElement()!).image()
                        .colorInvert()
                        .colorMultiply(colorless == false ?  color! : .white)
                        .frame(width: size, height: size)
                        
                
                
                
            }
            
            
        }

       
    }
}


struct MainPlacementView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
          //  MainPlacementView()
          //      .preferredColorScheme(.dark)
            MainPlacementView()
                .frame(width: 150)
                
        }
        
            //.frame(width: 25, height: 25)
    }
}

func randomColor() -> Color {
    
    var colors: [Color] = [.white, .red, .orange, .blue, .green, .yellow]
    
    return colors.randomElement()!
}




import SwiftUI

struct ConditionalColorInvert: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if colorScheme == .dark {
            return AnyView(content.colorInvert())
        } else {
            return AnyView(content)
        }
    }
}

extension View {
    func conditionalColorInvert() -> some View {
        self.modifier(ConditionalColorInvert())
    }
}

