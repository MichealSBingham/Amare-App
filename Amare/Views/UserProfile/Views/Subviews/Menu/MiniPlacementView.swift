//
//  MiniPlacementView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/27/23.
//

import SwiftUI
import LoremSwiftum
import Shimmer
struct MiniPlacementView: View {
    var interpretation: String?
    var planetBody: PlanetName?
    var sign: ZodiacSign?
    
    var numSentences: Int = 2
   
    
    var body: some View {
        
        ZStack{
            planetBody?.image_3D()
                .opacity(0.4)
            VStack{
                (Text(interpretation?.firstNSentences(numSentences) ?? Lorem.sentences(3)) + Text("..."))
                //.font(Font.custom("SF Pro Rounded", size: 14))
                    .redacted(reason: interpretation == nil ? .placeholder : [])
                    //.shimmering()
                    .multilineTextAlignment(.center)
                    .padding()
                   // .frame(width: 239, alignment: .top)
                
                HStack(spacing: 10){
                    
                    planetBody?.image().conditionalColorInvert()
                        .frame(height: 25)
                    
                    sign?.image().resizable().aspectRatio(contentMode: .fit).conditionalColorInvert()
                    
                        .frame(height: 25)
                    
                }
                .padding()
                
            }
        }
    }
}



struct DetailedMiniPlacementView: View {
    var interpretation: String?
    var planetBody: PlanetName?
    var sign: ZodiacSign?
    var house: Int?
    var angle: Double?
    var element: Element?
    
    var numSentences: Int = 2
   
    
    var body: some View {
        
        ZStack{
            planetBody?.image_3D()
                .opacity(0.4)
                .blur(radius: 3.0)
            
            VStack{
                NameDisplay()
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
                
                HStack(spacing: 10){
                    
                    planetBody?.image().conditionalColorInvert()
                        .frame(height: 25)
                    
                    sign?.image().resizable().aspectRatio(contentMode: .fit).conditionalColorInvert()
                    
                        .frame(height: 25)
                    
                }
             
                
                HouseLabel()
                
            }
        }
        /*
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                BackButton()
                    .padding()
                
            }
        }
        */

    }
    
    fileprivate func NameDisplay() -> some View {
        return Text("\(planetBody?.rawValue ?? PlanetName.allCases.randomElement()!.rawValue) in \(sign?.rawValue ?? "")")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
    }
    
    fileprivate func SignLabel() -> some View {
        return Text(sign?.rawValue ?? "")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
    }
    
    
    
   
    
    fileprivate func HouseLabel() -> HStack<TupleView<(some View, some View)>> {
        return HStack{
            
            
            var name_of_house = house?.toHouseNameOrd()
            Text("\(name_of_house?.rawValue ?? "") House")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.primary.opacity(0.4))
                .padding()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            
            
            var angle = angle?.dms ?? Double.random(in: 0..<30).dms
            
            Text("\(angle)")
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
    DetailedMiniPlacementView(interpretation: Lorem.paragraphs(8), planetBody: .Mars, sign: .Scorpio)
        .preferredColorScheme(.dark)
}
