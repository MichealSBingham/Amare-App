//
//  MiniAspectView.swift
//  Amare
//
//  Created by Micheal Bingham on 12/7/23.
//

import SwiftUI
import LoremSwiftum
import Shimmer
struct MiniAspectView: View {
    var interpretation: String?
    var firstBody: Body?
    var secondBody: Body?
    var orb: Double?
    var name: String?
    var aspectType: AspectType?
    
    
    var numSentences: Int = 0
    
    var body: some View {
        
        ZStack{
            
           bodyImages()
               
            
           
            
            VStack{
               
                  
                   // .padding()
                
                if numSentences == 0 {
                    Aspectname()
                    ScrollView{
                        
                    
                    (Text(interpretation ?? Lorem.sentences(3)) )
                            .lineSpacing(10)
                            .lineLimit(100)
                            .truncationMode(.tail)
                        .redacted(reason: interpretation == nil ? .placeholder : [])
                        //.shimmering()
                        .multilineTextAlignment(.center)
                        .padding()
                        
                    
                    
                }
                    .frame(height: 300)
                    .padding()
                } else{
                    (Text(interpretation?.firstNSentences(numSentences) ?? Lorem.sentences(3)) )
                            .lineSpacing(10)
                            .lineLimit(100)
                            .truncationMode(.tail)
                        .redacted(reason: interpretation == nil ? .placeholder : [])
                        //.shimmering()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                }
                    
                
                
               icons()
                
                if numSentences == 0 {
                    OrbLabel()
                }
                
                
            }
        }
        
       
        

    }


    
   fileprivate func Aspectname() -> some View {
       Text( "\(firstBody?.rawValue ?? "") \(aspectType?.rawValue ?? AspectType.allCases.randomElement()!.rawValue.capitalized) \(secondBody?.rawValue ?? "") ")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
            .minimumScaleFactor(0.01)
            .lineLimit(1)
    }
    
    
    fileprivate func bodyImages() -> some View {
        Group {
            if let firstPlanet = PlanetName(rawValue: firstBody?.rawValue ?? "") {
                firstPlanet.image_3D()
                    .opacity(0.4)
                    .offset(x: 50, y: 0)
            }
            
            if let secondPlanet = PlanetName(rawValue: secondBody?.rawValue ?? "") {
                secondPlanet.image_3D()
                    .offset(x:0, y: 50)
                    .opacity(0.4)
                   
            }
        }
    }
    
    fileprivate func icons() -> some View {
        HStack(spacing: 10) {
            
            if let firstPlanet = PlanetName(rawValue: firstBody?.rawValue ?? ""){
                firstPlanet.image().conditionalColorInvert()
                    .frame(height: 25)
            }
            
            
            if let secondPlanet = PlanetName(rawValue: secondBody?.rawValue ?? ""){
                secondPlanet.image().aspectRatio(contentMode: .fit).conditionalColorInvert()
                    .frame(height: 25)
            }
        
            
           
            
        }
    }

    
    fileprivate func OrbLabel() -> HStack<TupleView<(some View, some View)>> {
        return HStack{
            
            
            
            Text("Orb")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.primary.opacity(0.4))
                .padding()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            
            
            var orb = orb?.dms ?? Double.random(in: 0..<30).dms
            
            Text("\(orb)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.primary.opacity(0.4))
                .padding()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            
        }
    }
    
    
}

#Preview {
    MiniAspectView(interpretation: Lorem.paragraphs(8), firstBody: .Mars, secondBody: .Moon, orb: 2.4, name: "Jupiter Pluto", numSentences: 2)
    

}

/*

struct MiniPlacementVerticalPageView: View {
    var interpretations: [String: String] = [:]
    var planets: [Planet] = []

    @State  var selectedPlanet: Planet // Use a UUID or any unique identifier for planets

    var body: some View {
        TabView(selection: $selectedPlanet) {
            
            ForEach(planets) { planet in
                
            DetailedMiniPlacementView(
                        interpretation: interpretations[planet.name.rawValue],
                        planetBody: planet.name,
                        sign: planet.sign,
                        house: planet.house,
                        angle: planet.angle,
                        element: planet.element
                    )
                    //.rotationEffect(.degrees(-90), anchor: .center)
                    //.frame(width: .infinity, height: .infinity)
                    .tag(planet)
                .buttonStyle(PlainButtonStyle())
            }
        }
       // .rotationEffect(.degrees(90), anchor: .center)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            // Set the selected planet when the view appears (e.g., set it to the first planet)
           // selectedPlanetID = planets.first?.id
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                BackButton()
                    .padding()
                
            }
        }
    }
}
*/
