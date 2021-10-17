//
//  MoreInfoOnAspectView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/12/21.
//

import SwiftUI

struct MoreInfoOnAspectView: View {
    
    var planet: Planet?
    var planet2: Planet?
    var chart: NatalChart?
    
    var aspect: Aspect?
    
    /// False if this aspect is for synastry
    var isPersonal: Bool?
    
    // For the fade animation of the keywords of what it rules over
    @State var control2: Bool = false
    @State var counter2 = 0
    @State var sign: String = ""
    

    /* {
       Taking away fade modifer
        didSet{
            control2.toggle()
        }
        
    } */
    
    @State var control: Bool = false
    
    @State var nameOfPlanet: String = ""
    /* {
        
         Taking away fade motifer
        didSet{
            control.toggle()
        }
         
    }
         */
     
    // For alternating between latin and english
    @State var counter = 0
    
    // What the planet rules
   // var keywords = planet?.name.keywords() ?? [""]

    
    var body: some View {
        ZStack{
            
            VStack{
                
                HStack{
                    
                    ZStack{
                        planet3DImage()
                        planet3DImage2()
                            .offset(x: 50, y: 0)
                            .opacity(aspect?.first.rawValue == aspect?.second.rawValue ? 0: 1)
                    }.padding(.trailing)
                    
                    
                    VStack{
                        
                        
                       // HStack{
                            
                            planetNames()
                            //TODO: should be the aspect image instead
                           planetImage()
                            
                            
                            
                      //  }.padding()
                       
                        
                      
                        
                        aspectname()
                            .colorMultiply(aspect?.type.color() ?? [.blue as Color, .green, .red, .orange, .yellow].randomElement() as! Color)
                        
                        
                        
                      
                        
                    }
                   
                }
                
            
             
                //TODO: One line interpretation
               InterpretationOneLiner()
            
                //TODO: longer planet description
             //   LongerPlanetDescription().padding(.bottom)
            
                ZStack{
                    
                    HStack{
                        
                        elementImage()
                        element2Image()
                        
                       
                    }
                    .opacity((planet?.element ?? Element.allCases.randomElement()! !=  planet2?.element ?? Element.allCases.randomElement()!) ? 0: 1)
                    
                    elementImage()
                        .opacity(planet?.element ?? Element.allCases.randomElement()! == planet2?.element ?? Element.allCases.randomElement()! ? 1: 0)
                }
            
                
                
                
                // What this planet interacts with in their charts / aspects with
                
                /*
                //"Aspects"
                HStack{
                    
                    Text("Aspects")
                    .font(.largeTitle)
                     .bold()
                    // .frame(maxWidth : .infinity, alignment: .center)
                   // .padding(.bottom)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    //.minimumScaleFactor(0.01)
                   // .lineLimit(1)
                    
                   // Spacer()
                    
                    TabView{
                        
                
                            
                            HStack{
                                
                                // TODO: Planets that the sign aspects with
                                // TODO: Let this be vertical
                                PlanetName.allCases.randomElement()?.image()
                                    .colorInvert()
                                    .colorMultiply(Color.primary.opacity(0.4))
                                    .frame(width: 30, height: 30)
                                    
                                PlanetName.allCases.randomElement()?.image()
                                    .colorInvert()
                                    .colorMultiply(Color.primary.opacity(0.4))
                                    .frame(width: 30, height: 30)
                                PlanetName.allCases.randomElement()?.image()
                                    .colorInvert()
                                    .colorMultiply(Color.primary.opacity(0.4))
                                    .frame(width: 30, height: 30)
                            }
                    
                        
                        
                        
                        HStack{
                            
                            // TODO: Planets that the sign aspects with
                            // TODO: Let this be vertical
                            PlanetName.allCases.randomElement()?.image()
                                .colorInvert()
                                .colorMultiply(Color.primary.opacity(0.4))
                                .frame(width: 30, height: 30)
                            PlanetName.allCases.randomElement()?.image()
                                .colorInvert()
                                .colorMultiply(Color.primary.opacity(0.4))
                                .frame(width: 30, height: 30)
                            PlanetName.allCases.randomElement()?.image()
                                .colorInvert()
                                .colorMultiply(Color.primary.opacity(0.4))
                                .frame(width: 30, height: 30)
                        }
                        HStack{
                            
                            // TODO: Planets that the sign aspects with
                            // TODO: Let this be vertical
                            PlanetName.allCases.randomElement()?.image()
                                .colorInvert()
                                .colorMultiply(Color.primary.opacity(0.4))
                                .frame(width: 30, height: 30)
                            PlanetName.allCases.randomElement()?.image()
                                .colorInvert()
                                .colorMultiply(Color.primary.opacity(0.4))
                                .frame(width: 30, height: 30)
                            PlanetName.allCases.randomElement()?.image()
                                .colorInvert()
                                .colorMultiply(Color.primary.opacity(0.4))
                                .frame(width: 30, height: 30)
                        }
                       
                    }
                 
                    .frame(width: 100, height: 50)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                     .indexViewStyle(.page(backgroundDisplayMode: .never))
                    //.border(.white)
                   
                    
                     //.tabViewStyle(PageTabViewStyle())
                     //.rotationEffect(.degrees(90))
                    
                }
                .padding([.top, .bottom], -10)
                
                */
                
                
                //"House and degree"
                HStack{
                    
                    
                    //TODO: Change for producntion
                    var name_of_house = planet?.inWhatHouse(houses: chart?.houses ?? [])?.name() ?? /*"Unknown"*/ HouseNameOrd.allCases.randomElement()!.rawValue//
                    
                    Text("Orb")
                    .font(.largeTitle)
                     .bold()
                    // .frame(maxWidth : .infinity, alignment: .center)
                   // .padding(.bottom)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    
                    
                    
                    var angle = aspect?.orb.dms ?? Double.random(in: 0..<30).dms
                    
                    Text("\(angle)")
                    .font(.largeTitle)
                     .bold()
                   //  .frame(maxWidth : .infinity, alignment: .center)
                    //.padding(.bottom)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    
                }
                .padding([.top, .bottom],-10)
               // .padding(.bottom, 5)
                
                //TODO: Need to give more info on this
                //TODO: Call this FULL INTERPRETATION
                // We need to give them info on
                // (1) What this placement means
                // (2) Information on what house it is in and how it applies to them
                // (3) Information on the degree/cusps
                // (4) Information about its element
                // (5) Information about its modality
                // (6) Brief Information on what planets it interacts with
               TabView {
                   
                   VStack{
                       
                       
                       
                       Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.").padding()//padding(.bottom, 20)
                       
                      Spacer()
                       Spacer()
                   }
                
                 
                   
                    Text("Risus nullam eget felis eget nunc lobortis. Sapien nec sagittis aliquam malesuada. Venenatis lectus magna fringilla urna porttitor rhoncus dolor purus. Risus commodo viverra maecenas accumsan lacus vel facilisis volutpat. Adipiscing tristique risus nec feugiat in fermentum posuere. Dignissim enim sit amet venenatis urna cursus eget nunc. Sit amet consectetur adipiscing elit duis. A lacus vestibulum sed arcu. Vel quam elementum pulvinar etiam non quam. Convallis posuere morbi leo urna molestie at. Urna duis convallis convallis tellus id interdum. Sed viverra tellus in hac habitasse platea dictumst. Vestibulum morbi blandit cursus risus at ultrices mi tempus imperdiet. Volutpat maecenas volutpat blandit aliquam etiam erat. Nunc mattis enim ut tellus elementum. Metus vulputate eu scelerisque felis imperdiet proin fermentum leo vel. Viverra accumsan in nisl nisi scelerisque. Pharetra pharetra massa massa ultricies. Mauris pharetra et ultrices neque ornare aenean euismod elementum. Convallis convallis tellus id interdum velit laoreet id donec ultrices.").padding()
                   
                   
                   Text("Cursus turpis massa tincidunt dui ut ornare lectus sit. Odio euismod lacinia at quis risus sed vulputate odio ut. Sed cras ornare arcu dui vivamus arcu. Consectetur adipiscing elit ut aliquam purus sit amet. Aliquam ultrices sagittis orci a. Orci ac auctor augue mauris augue. Consequat nisl vel pretium lectus quam id. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi. Dolor sed viverra ipsum nunc aliquet bibendum enim. Molestie at elementum eu facilisis sed. Aliquam ultrices sagittis orci a scelerisque purus.").padding()
                   
                   
                   Text("Sit amet nulla facilisi morbi tempus. Vestibulum lectus mauris ultrices eros in. Risus viverra adipiscing at in tellus integer feugiat scelerisque. Nec nam aliquam sem et. Vel quam elementum pulvinar etiam non quam lacus suspendisse. Amet nulla facilisi morbi tempus iaculis. Purus sit amet volutpat consequat mauris nunc congue nisi. Turpis egestas maecenas pharetra convallis posuere morbi leo. Ornare suspendisse sed nisi lacus sed viverra tellus in. Eget nunc scelerisque viverra mauris in aliquam sem.").padding()
                   
                   Text("At urna condimentum mattis pellentesque id. Ut sem nulla pharetra diam sit amet. Sed enim ut sem viverra. Eget nunc lobortis mattis aliquam faucibus purus in massa tempor. Ullamcorper velit sed ullamcorper morbi tincidunt ornare massa eget. Convallis convallis tellus id interdum velit. Adipiscing elit pellentesque habitant morbi. Ultricies integer quis auctor elit sed. Tortor aliquam nulla facilisi cras fermentum odio eu feugiat pretium. Faucibus nisl tincidunt eget nullam non nisi est sit amet. Eget sit amet tellus cras adipiscing enim eu turpis.").padding()
                   
                   
                }
                
               .indexViewStyle(.page(backgroundDisplayMode: .interactive))
              // .frame(width: .infinity, height: 150)
               .tabViewStyle(.page)
              //.padding(.top, -50)
               //.border(.white)
                
                
                
              
                /*
                
                HStack{
                    //Should alternate definitions
                    
                    /*
                    Text("House")
                        .font(.largeTitle)
                         .bold()
                       //  .frame(maxWidth : .infinity, alignment: .center)
                      //  .padding(.top)
                        .foregroundColor(Color.primary.opacity(0.4))
                    */
                    
                    atHomeIn()
                }
                 
                 */
                
                /*
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
                */
                
                
                
             
                
            //Spacer()
            }
        //.frame(width: .infinity-50, height: 700)
            
        }
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.primary.opacity(0.35))
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
        .frame(width: .infinity-60, height: 700)
        //.frame(width: 700, height: 700)
    }
    
    
    /// Returns the house that the planet is at home in
    func atHomeIn() -> some View {
        
        var name_of_house =  planet?.inWhatHouse(houses: chart?.houses ?? [])?.name() ?? "Unknown"
        
        
       // ?? HouseNameOrd.allCases.randomElement()!.rawValue
        
       
      
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
        
        var mockplanet  = Planet(name: .Moon, angle: 21.3, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: "You have intense, deep, and powerful emotions.", sign: .Scorpio, cusp: nil, speed: 23)
        
        var desc = planet?.longer_placement_interpretation ?? mockplanet.longer_placement_interpretation ?? "Nothing to say here."
        
        return Text(.init(desc))
            .multilineTextAlignment(.center)
    }
    
    func InterpretationOneLiner() -> some View {
        
        var mockplanet  = Planet(name: .Moon, angle: 21.3, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: "You have intense, deep, and powerful emotions.", sign: .Scorpio, cusp: nil, speed: 23)
       
        

        //var desc = planet?.one_line_placement_interpretation ?? mockplanet.one_line_placement_interpretation ?? "Nothing to say here."
        
        var desc = aspect?.interpretation ?? "One line summary of this aspect."
        //var markdownText: AttributedString = try! AttributedString(markdown: desc)
        
        return Text(desc)
            .font(.title)
              //.bold()
              //.frame(maxWidth : .infinity, alignment: .center)
            .padding()
             .foregroundColor(Color.primary.opacity(0.4))
           // .foregroundColor(.white)
             .multilineTextAlignment(.center)
             //.minimumScaleFactor(0.5)
             //.lineLimit(1)
        
    }
    
    func planetNames() -> some View {
        
     
      //  var planetName = planet?.name ??  PlanetName.allCases.randomElement()!
      //  var name: String = "Your \(planet?.name.rawValue ?? PlanetName.allCases.randomElement()!.rawValue)\n their \(planet2?.name.rawValue ?? PlanetName.allCases.randomElement()!.rawValue)"
        
        var name: String = "Your \(aspect?.first.rawValue ?? PlanetName.allCases.randomElement()!.rawValue)\n and \(aspect?.second.rawValue ?? PlanetName.allCases.randomElement()!.rawValue)"
    
       return Text(name)
            .font(.largeTitle)
             .bold()
            // .modifier(FadeModifier(control: control))
           
             // Duration of the fade animation
             // .animation(.easeInOut(duration: 2))
             //.frame(maxWidth : .infinity, alignment: .center)
             .minimumScaleFactor(0.01)
             //.scaledToFit()
            .foregroundColor(Color.primary.opacity(0.4))
            .multilineTextAlignment(.center)
       /*     .onReceive(timer) { _ in
                
                //TODO: these should not animate at same time
               
                if counter % 2 != 0 {
                    withAnimation {
                    
                        
                      //  keyword = planet?.name.keywords().randomElement()! ?? ""
                        
                        sign = (planet?.sign.rawValue ?? "")
                        nameOfPlanet = planetName.rawValue

                      /*  AmareApp().delay(1) {
                            withAnimation {
                                
                                
                                
                                nameOfPlanet = planetName.rawValue

                            }
                            
                        } */
                        
                     

                    }
                    
                    
                } else {
                    
                    // Latin Translation
                    withAnimation {
                        
                        //TODO: FIx
                        sign =  (planet?.sign.rawValue ?? "").latin()
                        
                        nameOfPlanet = planetName.rawValue

                        nameOfPlanet = planetName.rawValue.latin()

                        
                       /* AmareApp().delay(1) {
                            withAnimation {
                                nameOfPlanet = planetName.rawValue.latin()

                            }
                            
                        }*/
                        

                    }
                    
                }
                
                counter += 1
                
            } */
           /* .onAppear {
                nameOfPlanet = planetName.rawValue
            }
        */
        
    }
    
    ///  The symbol of the planet
    func planetImage() -> some View {
        //TODO: Change this to show aspect planets 
        return  MainPlacementView( planet: planet, size: 40, colorless: true)
        
           // .padding()
        
            /*
          return   (planet?.name ?? PlanetName.allCases.randomElement()!).image()
                .colorInvert()
               // .aspectRatio( contentMode: .fit)
               // .colorMultiply(color!)
                .frame(width: 50, height: 50)
            */
        
    }
    
    ///  The symbol of the planet
    ///  TODO: change the default planet to not moon, which theoretically shouldn't matter because it should never be called anyway.
    func planet3DImage() -> some View {
        
     //   var firstplanetname: String?  = aspect?.first.rawValue
        
            // var firstplanet =
        
        return   (PlanetName(rawValue: aspect?.first.rawValue ?? "") ?? PlanetName.allCases.randomElement()!).image_3D()
                    .frame(width: 150, height: 150)
            
        
    }
    
    func planet3DImage2() -> some View {
    
        
            
        return   ((PlanetName(rawValue: aspect?.second.rawValue ?? "")) ??  PlanetName.allCases.randomElement()!).image_3D()
                    .frame(width: 150, height: 150)
            
        
    }
    
    //TODO: Correct the element.... we can just pass the proper element here when we call the structure
    func elementImage() -> some View {
        
       
       
        // The element of the planet
        let el = planet?.element
      return  (el ?? Element.allCases.randomElement()!).image()
            //.padding()
    }
    
    
    
    //TODO: Correct the element.... we can just pass the proper element here when we call the structure
    func element2Image() -> some View {
        
       
       
        // The element of the planet
        let el = planet2?.element
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
    func aspectname() -> some View {
        
        
       
        
        
        
        return Text( aspect?.type.rawValue ?? AspectType.allCases.randomElement()!.rawValue.capitalized)
             .font(.largeTitle)
              .bold()
              .frame(maxWidth : .infinity, alignment: .center)
           // .padding()
             .foregroundColor(Color.primary.opacity(0.4))
             .minimumScaleFactor(0.01)
            //  .modifier(FadeModifier(control: control2))
             //.transition(.opacity)
           /*  .onReceive(timer) { _ in
                 
                
                 if counter2 % 2 != 0 {
                     withAnimation {
                         
                         keyword = planet?.name.keywords()[1] ?? "idk"
                     }
                     
                 } else {
                     
                     withAnimation {
                        
                    
                         keyword = /*planet?.name.keywords()[2] ?? */"idk"
                     }
                     
                 }
                 
                 counter2 += 1
                 
             }
        */
             .onAppear {
               //  keyword = planet?.name.keywords()[0] ?? "Not Known"
                 sign = planet?.sign.rawValue ?? ""
                 nameOfPlanet = planet?.name.rawValue
                 ?? ""
             }
             
    }
    
    
    
    

}

struct MoreInfoOnAspectView_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoOnAspectView().preferredColorScheme(.dark)
    }
}