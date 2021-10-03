//
//  MoreInfoOnGenericPlanet.swift
//  Amare
//
//  Created by Micheal Bingham on 10/3/21.
//

import SwiftUI

struct MoreInfoOnGenericPlanet: View {
    
    var planet: Planet?
    
    @State var keyword: String?
    
    var body: some View {
        ZStack{
            
            VStack{
                
                HStack{
                    
                    planet3DImage()
                    
                    VStack{
                        
                        
                        HStack{
                            
                            planetName()
                            
                            planetImage()
                        }.padding()
                       
                        
                      
                        
                        alternatingTextOfWhatItRules()
                        
                        
                        
                      
                        
                    }
                   
                }
                
            
             
                
               PlanetDescription()
            
                LongerPlanetDescription().padding(.bottom)
            
                elementImage()
                
              
                
                HStack{
                    //Should alternate definitions
                    Text("At Home in ")
                        .font(.largeTitle)
                         .bold()
                       //  .frame(maxWidth : .infinity, alignment: .center)
                      //  .padding(.top)
                        .foregroundColor(Color.primary.opacity(0.4))
                    
                    atHomeIn()
                }
                
                HStack{
                    Spacer()
                    //TODO: Should also say , alternative between
                    // Domicile
                    Text("Rules")
                        .font(.largeTitle)
                         .bold()
                        // .frame(maxWidth : .infinity, alignment: .center)
                      //  .padding(.top)
                        .foregroundColor(Color.primary.opacity(0.4))
                    
                    Spacer()
                    planet?.sign.image()
                        .colorInvert()
                    
                    Spacer()
                       
                }
                
                
             
                
                Spacer()
            }
            
        }
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.primary.opacity(0.35))
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
    }
    
    
    /// Returns the house that the planet is at home in
    /// TODO: calculate what house the planet rules
    func atHomeIn() -> some View {
        
        var name_of_house =  HouseNameOrd.allCases.randomElement()!.rawValue
      
     return  Text("\(name_of_house) House")
      .font(.largeTitle)
       .bold()
      // .frame(maxWidth : .infinity, alignment: .center)
     // .padding(.bottom)
      .foregroundColor(Color.primary.opacity(0.4))
      .padding()
      .minimumScaleFactor(0.01)
      .lineLimit(1)

    }
    
    func LongerPlanetDescription() -> some View {
        
        var desc = (planet?.name ?? PlanetName.allCases.randomElement()! ).longerDescription()
        
        return Text(.init(desc))
            .multilineTextAlignment(.center)
    }
    func PlanetDescription() -> some View {
        
       

        var desc = (planet?.name ?? PlanetName.allCases.randomElement()! ).description()
        
        //var markdownText: AttributedString = try! AttributedString(markdown: desc)
        
        return Text(desc)
            .font(.title)
              //.bold()
              .frame(maxWidth : .infinity, alignment: .center)
            .padding()
             .foregroundColor(Color.primary.opacity(0.4))
           // .foregroundColor(.white)
             .multilineTextAlignment(.center)
    }
    
    func planetName() -> some View {
        
        var planetName = planet?.name ??  PlanetName.allCases.randomElement()!
        
       return Text(planetName.rawValue)
            .font(.largeTitle)
             .bold()
             .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
    }
    
    ///  The symbol of the planet
    func planetImage() -> some View {
        
        
            
          return   (planet?.name ?? PlanetName.allCases.randomElement()!).image()
                .colorInvert()
               // .aspectRatio( contentMode: .fit)
               // .colorMultiply(color!)
                .frame(width: 50, height: 50)
            
        
    }
    
    ///  The symbol of the planet
    ///  TODO: change the default planet to not moon, which theoretically shouldn't matter because it should never be called anyway.
    func planet3DImage() -> some View {
        
        
            
        return   (planet?.name ?? PlanetName.Moon).image_3D()
                    .frame(width: 150, height: 150)
            
        
    }
    
    //TODO: Correct the element.
    func elementImage() -> some View {
        
        // The element of the planet
        let el = planet?.element
      return  (el ?? Element.allCases.randomElement()!).image()
            //.padding()
    }
    
    //TODO: Correct the element.// ignore, planets do not have modality
    /*
    func modalityImage() -> some View {
        
        // The element of the planet
        let modality = planet?.modality
        return  (modality ?? Element.allCases.randomElement().modality!).image()
            //.padding()
    }
    */
    
    
    
    //TODO:
    func alternatingTextOfWhatItRules() -> some View {
        
        var keywords = planet?.name.keywords() ?? [""]
        
        let timer = Timer.publish(every: 2, on: .main, in: .default).autoconnect()
        
        
        
        return Text(keyword ?? keywords.first!)
             .font(.largeTitle)
              .bold()
              .frame(maxWidth : .infinity, alignment: .center)
           // .padding()
             .foregroundColor(Color.primary.opacity(0.4))
             // .modifier(FadeModifier(control: keyword != nil))
             .onReceive(timer) { _ in
                 withAnimation(.easeIn(duration: 3)){
                     keyword = keywords.randomElement()!
                 }
                 
             }
             
    }
    
    
    
    

}

struct MoreInfoOnGenericPlanet_Previews: PreviewProvider {
    static var previews: some View {
        
        var p  = Planet(name: .Moon, angle: 21.3, element: .water, onCusp: false, retrograde: false, sign: .Cancer, cusp: nil, speed: 23)
        
        MoreInfoOnGenericPlanet(planet: p).preferredColorScheme(.dark)
    }
}
