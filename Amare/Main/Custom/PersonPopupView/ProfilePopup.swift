//
//  ProfilePopup.swift
//  Amare
//
//  Created by Micheal Bingham on 10/1/21.
//

import SwiftUI
import UICircularProgressRing


// Some random data to use as mock
var peopleImages = ["https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo", testImages[0],

"https://www.mainewomensnetwork.com/Resources/Pictures/vicki%20aqua%20headshot-smallmwn.jpg",
"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_tBdq4KSetrBr7nGFHxwxMZkrcBVp8SPpDA&usqp=CAU"]

var colors: [Color] = [.gray, .green, .blue, .red, .orange]


struct ProfilePopup: View {
    
    /*@State*/ var user: AmareUser?
    
    @State var showProfilePopup: Bool = false
    
    
    @State var showAddFriend: Bool = true
    @State var showBottomPopup: Bool = false
    @State var infoToShow:String?
    @State private var chart: NatalChart?
    
    // Properties for the profile pop up
    @State var synastryscore = RingProgress.percent(0)
    @State var chemistry = RingProgress.percent(0)
    @State var love = RingProgress.percent(0)
    @State var sex = RingProgress.percent(0)
    
    var body: some View {
        
        ZStack{
            
            
            
            VStack{
                
                
                ZStack{
                    
                    Button {
                        print("tapped profile to view images")
                    } label: {
                        
                        ImageFromUrl(user?.profile_image_url ?? peopleImages.randomElement()!)
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 100, height: 100)
                             .clipShape(Circle())
                             .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                             .shadow(radius: 15)
                    }

                    
                   
                    
                    HStack{
                        Spacer()
                        
                        
                        ZStack{
                            
                            Button {
                                
                                showAddFriend.toggle()
                            } label: {
                                
                                ZStack{
                                    
                                    
                                    Image(systemName: "plus.circle")
                                        .modifier(ConvexGlassView())
                                         .opacity(showAddFriend ? 1: 0 )
                                     
                                    
                                    
                                    Image(systemName: "plus.circle.fill")
                                          .modifier(ConcaveGlassView())
                                          .opacity(showAddFriend == false ? 1 : 0)
                                     
                                }
                                
                               
                                
                                
                                
                            }.offset(x: 10, y: -35.0)
                            
                           
                        }
                        
                        

                              
                      
                    }
                    
                }
                  
                
                // Name
                Text("\(user?.name ?? sampleNames.randomElement()!)")
                            .font(.largeTitle)
                             .bold()
                             .frame(maxWidth : .infinity, alignment: .center)
                            //.padding(.top)
                            .foregroundColor(Color.primary.opacity(0.4))
                            .modifier(FadeModifier(control: showProfilePopup))
                
                
                
                
                    // Classification
                Text("\(sampleClassifications.randomElement()!)")
                                    .font(.callout)
                                    .frame(maxWidth : .infinity, alignment: .center)
                                    .foregroundColor(Color.primary.opacity(0.4))
                                    .padding(.bottom)
                                    .modifier(FadeModifier(control: showProfilePopup))
                                   // .shimmering(duration: 5, bounce: true)
                
                
                // Latin Phrase
                Text("\(sampleLatinPhrases.randomElement()!)")
                                    .font(.callout)
                                    .frame(maxWidth : .infinity, alignment: .center)
                                    .foregroundColor(Color.primary.opacity(0.4))
                                    .modifier(FadeModifier(control: showProfilePopup))
                                  
                                   // .shimmering(duration: 5, bounce: true)
                                   // .padding([.bottom, .top])
                TabView{
                    
                    HStack{
                        
                   
                        
                        MainPlacementView( planet: user?.natal_chart?.planets.get(planet: .Sun), size: 20).padding(.trailing)
                            
                        
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Moon), size: 20).padding(.trailing)
                        
                      
                    MainPlacementView_Angle(angle: user?.natal_chart?.angles.get(planet: .asc), size: 20).padding(.trailing)
                        
                        
                     
                    }
                        
                    HStack{
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Mercury), size: 20).padding(.trailing)
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Venus), size: 20).padding(.trailing)
                        
                
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Mars), size: 20).padding(.trailing)
                    }
                        
                    HStack{
                        
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Jupiter), size: 20).padding(.trailing)
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Saturn), size: 20).padding(.trailing)
                        
                    
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Uranus), size: 20).padding(.trailing)
                    }
                        
                       
                    HStack{
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Neptune), size: 20).padding(.trailing)
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .Pluto), size: 20).padding(.trailing)
                        
                        
                    }
                    
                    HStack{
                        
                        
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .NorthNode), size: 20).padding(.trailing)
                        
                       
                        MainPlacementView(planet: user?.natal_chart?.planets.get(planet: .SouthNode), size: 20).padding(.trailing)
                    }
                    
                    HStack{
                        
                        MainPlacementView_Angle(angle: user?.natal_chart?.angles.get(planet: .ic), size: 20).padding(.trailing)
                        
                        MainPlacementView_Angle(angle: user?.natal_chart?.angles.get(planet: .mc), size: 20).padding(.trailing)
                        
                        MainPlacementView_Angle(angle: user?.natal_chart?.angles.get(planet: .desc), size: 20).padding(.trailing)
                    }
                        
                        
                    
                        
                        
                        
                        
                    
                   
                }
             
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .frame(width: .infinity, height: 150)
                .tabViewStyle(.page)
                .padding(.top, -50)
             
              
                    
                
                                    
                
                // Ring styles for progress circles
                let o_ringstyle: RingStyle = .init(
                    color: .color(.gray),
                    strokeStyle: .init(lineWidth: 10)
                )
                
              
               
                    
                
                
                TabView {
                    
                        
                    
                                
                      // Synastry Score
                                ProgressRing(progress: $synastryscore, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "synastry")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }//.animation(.easeInOut(duration: 5))
                                    .frame(width: 150, height: 150)
                                    .onAppear {
                                        AmareApp().delay(1) {
                                            
                                            withAnimation(.easeInOut(duration: 3)) {
                                                synastryscore = RingProgress.percent(Double.random(in: 0...1))
                                            }
                                        }
                                       
                                    }
                    
                                  
                                
                                
                 // Chemistry, Love, Sex
                    HStack{
                                ProgressRing(progress: $chemistry, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "chemistry")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                        Text("Chemistry")
                                            .font(.subheadline)
                                            
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }
                                    .frame(width: 115, height: 115)
                                    .onAppear {
                                        
                                        withAnimation(.easeInOut(duration: 3)) {
                                            chemistry = RingProgress.percent(Double.random(in: 0...1))

                                        }
                                    }
                                
                                
                                ProgressRing(progress: $love, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "love")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                        Text("Love")
                                            .font(.subheadline)
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }
                                    .frame(width: 115, height: 115)
                                    .onAppear {
                                        
                                        withAnimation(.easeInOut(duration: 3)) {
                                            love = RingProgress.percent(Double.random(in: 0...1))

                                        }
                                    }
                                
                                ProgressRing(progress: $sex, axis: .top, clockwise: true, outerRingStyle: o_ringstyle, innerRingStyle: ringStyleFor(progress: "sex")) { percent in
                                    
                                    
                                    let pcent = Int(round(percent*100))
                                    
                                    VStack{
                                        
                                        Text("Sex")
                                            .font(.subheadline)
                                            
                                        
                                        Text("\(pcent)")
                                                        .font(.title)
                                                        .bold()
                                    }
                                    
                                    
                                }
                                    .frame(width: 115, height: 115)
                                    .onAppear {
                                        
                                        withAnimation(.easeInOut(duration: 3)) {
                                            sex = RingProgress.percent(Double.random(in: 0...1))

                                        }
                                    }
                        
                    }
                            
                    Button(action: {
                        print("Tapped natal chart")
                    }) {
                        
                        SmallNatalChartView()
                            .makeSmall(with: chart)
                        
                    }
                
                       
                            
                        }
                        
                        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                        .frame(width: .infinity, height: 150)
                        .tabViewStyle(.page)
                
                
                
                     
                     
                }
            
            
            
        }
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.primary.opacity(0.35))
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .onAppear(perform: {
            
                withAnimation {
                    showProfilePopup = true
                
              
            }
       
        })
    }
    
    func ringStyleFor(progress: String ) -> RingStyle {
        
        var color: Color = .green
        
        var number = 0.0
    
        switch progress {
        case "synastry":
            number = synastryscore.asDouble ?? 0
        case "chemistry":
            number = chemistry.asDouble ?? 0
        case "sex":
            number = sex.asDouble ?? 0
        case "love":
            number = love.asDouble ?? 0
        default:
            number = 0
        }
        
         number = number*100
        
        if number <= 25.0 { color = .red }
        if number > 25.0 {color = .orange}
        if number >= 40.0  {color = .yellow}
        if number >= 60.0 { color = .green }
        if number >= 85.0 {color = .blue}
        
                
        
       return  .init(
                        color: .color(color),
                        strokeStyle: .init(lineWidth: 5),
                        padding: 2.5)
    }
}

struct ProfilePopup_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePopup().preferredColorScheme(.dark)
    }
}
