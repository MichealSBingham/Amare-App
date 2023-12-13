//
//  MoreInfoOnGenericPlanet.swift
//  Amare
//
//  Created by Micheal Bingham on 10/3/21.
//

import SwiftUI
import Firebase
import Combine

struct MoreInfoOnPlanet: View {
    
    @StateObject var viewModel: MoreInfoOnPlanetViewModel = MoreInfoOnPlanetViewModel()
    
    /*@State*/ var planet: Planet?
    var chart: NatalChart?
    


  
    
    /// State to dismiss view or not  
    @Binding var exit: Bool
    
   

    
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
    
    // The aspect the user selected
    @State var aspectSelected: Aspect?
    
    var mockplanet  = Planet(name: .Moon, angle: 21.3, element: .water, onCusp: false, retrograde: false, one_line_placement_interpretation: "You have intense, deep, and powerful emotions.", sign: .Scorpio, cusp: nil, speed: 23)
    
     
    // For alternating between latin and english
    @State var counter = 0
    
    // What the planet rules
   // var keywords = planet?.name.keywords() ?? [""]
    
   // @State var otherNotableUsersWithAspect: [AmareUser] = []

    
    var body: some View {
        
        
        ZStack{
            
         
            
            VStack{
                
                HStack{
                    
                    planet3DImage()
                    
                    VStack{
                        
                        
                            
                            planetName()
                            .onAppear {
                                guard planet != nil else { return }
                                viewModel.findPeople(with: planet!)
                            }
                            
                           planetImage()
                            
                            
                       
                        
                      
                        
                        alternatingTextOfWhatItRules()
                        

                    }
                   
                }
                
            
             
                //TODO: One line interpretation
               InterpretationOneLiner()
                  
            
                //TODO: longer planet description
             //   LongerPlanetDescription().padding(.bottom)
            
                
            
                    
                ZStack{
                    
                    elementImage()
                    
                    HStack {
                        
                        friendsWithPlacementViews()
                        
                        Spacer()
                        
                        notablePeopleWithPlacementViews()
                   
                        
                    }.padding(-10)
                    
                    
                }
                
                 
                    
                   
                
              
                
                
                // What this planet interacts with in their charts / aspects with
                
                //"Aspects"
				/*
                HStack{
                    
                    AspectsText()
                    
                    
                    ScrollView(.horizontal){
                    
                     
                        HStack{
                            
                            ForEach(chart?.aspectsInvolving(some: planet ?? mockplanet) ?? [], id: \.id){ aspect in
                                //TODO: Should show the bodies
                                
                            
                                
                        
                                
                                // If they're both planets
                                if let p1 = PlanetName(rawValue: aspect.first.rawValue), let p2 = PlanetName(rawValue: aspect.second.rawValue){
                                    
                                    let aspectedPlanet = (planet?.name != p1) ? p1 : p2
                                    
                                    if aspect.type != .none{
                                        
                                        
                                        Button {
                                            
                                            withAnimation {
                                                
                                              
                                                NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: aspect)
                                                aspectSelected = aspect
                                            }
                                           
                                        
                                        } label: {
                                            
                                            aspectedPlanet.image()
                                                .colorInvert()
                                                .colorMultiply(aspect.type.color())
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                                   
                                    
                                }
                            
                        /*
                                if let planet = PlanetName(rawValue: aspect.first.rawValue){
                                    
                                    Button {
                                        
                                        withAnimation {
                                            
                                            aspectSelected = aspect
                                        }
                                       
                                    
                                    } label: {
                                        
                                        planet.image()
                                            .colorInvert()
                                            .colorMultiply(Color.primary.opacity(0.4))
                                            .frame(width: 30, height: 30)
                                    }

                                    
                                   
                                    
                                }
                                
                                if let angle = PlanetName(rawValue: aspect.first.rawValue){
                                    
                                    Button{
                                        withAnimation {
                                            
                                            aspectSelected = aspect
                                        }
                                       

                                        
                                    } label: {
                                        
                                        angle.image()
                                            .colorInvert()
                                            .colorMultiply(Color.primary.opacity(0.4))
                                            .frame(width: 30, height: 30)
                                    }
                                    
                                } else{
                                    
                                    Text("\(aspect.type.rawValue)")
                                }
                                
                                */
                            }
                            
                        }
                        
                     
                        
                
                            /*
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
                             */
                       
                    }
                 
                    .frame(width: 100, height: 50)
                    //.tabViewStyle(.page(indexDisplayMode: .never))
                    // .indexViewStyle(.page(backgroundDisplayMode: .never))
                
                    
                }
                .padding([.top, .bottom], -10)
                */
                
                //"House and degree"
                HStack{
                    
                    
                    //TODO: Change for producntion
                    //var name_of_house = planet?.inWhatHouse(houses: chart?.houses ?? [])?.name() ?? /*"Unknown"*/ HouseNameOrd.allCases.randomElement()!.rawValue//
                    
                    var name_of_house = planet?.house?.toHouseNameOrd()
                    Text("\(name_of_house?.rawValue ?? "") House")
                    .font(.largeTitle)
                     .bold()
                    // .frame(maxWidth : .infinity, alignment: .center)
                   // .padding(.bottom)
                    .foregroundColor(Color.primary.opacity(0.4))
                    .padding()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    
                    
                    
                    var angle = planet?.angle.dms ?? Double.random(in: 0..<30).dms
                    
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
                // TODO: only show this if house is available (birthtiem)
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
                
                
                
              
              
             
                
                
             
                
           
            }
        //.frame(width: .infinity-50, height: 700)
            
            //TODO: incompelte 
           // MoreInfoOnAspectView(chart: chart, aspect: aspectSelected)
               // .opacity(aspectSelected != nil ? 1: 0 )
            
            VStack{
                
                HStack{
                    
                    Spacer()
                    Button{
                        
                        print("Exit")
                        NotificationCenter.default.post(name: NSNotification.exitPlacements, object: nil)
                        withAnimation{
                            
                            exit = true
                            
                        }
                        
                    } label: {
                        
                        Image(systemName: "xmark").resizable()
                            .foregroundColor(.red.opacity(0.5))
                            .clipShape(Circle())
                            .frame(width: 25, height: 25)
                            
                            //.ignoresSafeArea()
                            //.offset(x: -20, y: -40)
                    }
                    
                        
                    
                }
                
                
                Spacer()
            }
            
            
        }
        
        .onAppear(perform: {
            
            sign = planet?.sign.rawValue ?? ""
            nameOfPlanet = planet?.name.rawValue
            ?? ""
            
            // Loads people with this placement (friends and notables)
           
            print("ON APPEAR Just changed planet on appear \(planet) ")
            guard let p = planet else  {
               print("Can't get planet")
                return
            }
            
            /*
            withAnimation{
                viewModel.findPeople(with: p)
            }
            */
           
            
                
        })
      /*  .onChange(of: friendsWithPlacement, perform: { friends in
            
            print("JUST CHANGED friends \(friends)")
            /*
            if friendsWithPlacement != [] { _friendsWithPlacement = friendsWithPlacement}
             */
                /* if friends == []{
                print("EMPTY FRIENDS ")
                // Fail safe so reload friends
                
                guard let p = planet else {return }
                fail_safe_viewModel.findPeople(with: p)
                friendsWithPlacement = fail_safe_viewModel.friendsWithThisPlacement
                
                print("Fail safe : \(fail_safe_viewModel.friendsWithThisPlacement)")
            } */
        })
       .onChange(of: notablesWithPlacement, perform: { notables in
            
            //if notables != [] { _notables = notables}
            /*
            print("JUST CHANGED notables \(notables)")
            if notables == []{
                print("EMPTY NOTABLES ")
                guard let p = planet else {return }

                // fail safe so reload notables
                fail_safe_viewModel.findPeople(with: p)
                notablesWithPlacement   = fail_safe_viewModel.notablePeopleWithThisPlacement
                
                print("Fail safe : \(fail_safe_viewModel.notablePeopleWithThisPlacement)")
            } */
        }) */
      /*  .onChange(of: planet, perform: { planet in
            
            print("Just changed planet its... \(planet)")
            guard let p = planet else  {
               print("Can't get planet")
                return
            }
            
            
            withAnimation{
                
                viewModel.findPeople(with: p)
            }
        })
        */
        
        
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
       
        

        var desc = planet?.one_line_placement_interpretation ?? mockplanet.one_line_placement_interpretation ?? "Nothing to say here."
        
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
    
    func planetName() -> some View {
        
        let timer = Timer.publish(every: 3, on: .main, in: .default).autoconnect()
        
      //  var planetName = planet?.name ??  PlanetName.allCases.randomElement()!
        
    
       return Text(planet?.name.rawValue ?? "")
            .font(.largeTitle)
             .bold()
            // .modifier(FadeModifier(control: control))
           
             // Duration of the fade animation
             // .animation(.easeInOut(duration: 2))
             .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
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
        
        return  MainPlacementView()
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
        
        
            
        return   (planet?.name ?? PlanetName.Moon).image_3D()
                    .frame(width: 150, height: 150)
            
        
    }
    
    //TODO: Correct the element.... we can just pass the proper element here when we call the structure
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
        
        
        let timer = Timer.publish(every: 2, on: .main, in: .default).autoconnect()
        
        
        
        return Text(planet?.sign.rawValue ?? "")
             .font(.largeTitle)
              .bold()
              .frame(maxWidth : .infinity, alignment: .center)
           // .padding()
             .foregroundColor(Color.primary.opacity(0.4))
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
                

             }
             
             
    }
    
    //TODO: change the name
    ///    Current User's Planet
    ///    TODO: Change what this says
    func AspectsText() -> some View {
        
        Text("Aspects")
        .font(.largeTitle)
         .bold()
        // .frame(maxWidth : .infinity, alignment: .center)
       // .padding(.bottom)
        .foregroundColor(Color.primary.opacity(0.4))
        .padding()
    }
    
    
    
    func notablePeopleWithPlacementViews() -> some View {
        
        
       
        
       return  Button {
            //go to notable people
        } label: {
            
            ZStack {
                
                
                if !$viewModel.notablePeopleWithThisPlacement.isEmpty{
                    
                    
                    ForEach($viewModel.notablePeopleWithThisPlacement.prefix(5).indices, id: \.self) {
                         index in
                        
                        
                        let offset: CGFloat = CGFloat(10+(5*index))

                     /*   let i: Double = 5*index
                        let o: Double = -10 - i
                        let offset: CGFloat = CGFloat(o) */
                        
                        let image: String? = viewModel.notablePeopleWithThisPlacement[index].profile_image_url
                        
                        ImageFromUrl(image ?? "    https://lh3.googleusercontent.com/ogw/ADea4I5VDilLtQfyS7bwoGxcMqXW46dRo_ugPf4ombhR=s192-c-mo")
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke([.white, .red, .orange, .blue, .green, .yellow].randomElement() ?? .blue, lineWidth: 1))
                            .shadow(radius: 15)
                            .padding([.leading, .trailing])
                            .offset(x: index == 0 ? 0: offset)
                        
                    }
                    
                }
                
                
                
                
                
                
       
  
                
            }
        }

            

            
        
        
        
    }
    
    
    func friendsWithPlacementViews() -> some View {
        
        return  Button {
             //go to notable people
         } label: {
             
             ZStack {
                 

                 //if !(viewModel.friendsWithThisPlacement.isEmpty ?? true)
                // {
                     
                 ForEach($viewModel.friendsWithThisPlacement.prefix(5).indices, id: \.self) {
                          index in
                         
                         let offset: CGFloat = CGFloat(10+(5*index))
                         
                         ImageFromUrl(viewModel.friendsWithThisPlacement[index].profile_image_url ?? peopleImages.randomElement()!)
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                             .overlay(Circle().stroke([.white, .red, .orange, .blue, .green, .yellow].randomElement() ?? .blue, lineWidth: 1))
                             .shadow(radius: 15)
                             .padding([.leading, .trailing])
                             .offset(x: index == 0 ? 0: offset)
                         
                     }
                     
               //  }
                
                 
                 
                 
                
   
                 
             }
         }


        
        
        /*
        return  Button {
             //go to notable people
         } label: {
             
             ZStack {
                 
                 ImageFromUrl(peopleImages[3])
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 50, height: 50)
                     .clipShape(Circle())
                     .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                     .shadow(radius: 15)
                     .padding([.leading, .trailing])
                 
                 ImageFromUrl(peopleImages[2])
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 50, height: 50)
                     .clipShape(Circle())
                     .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                     .shadow(radius: 15)
                     .padding([.leading, .trailing])
                     .offset(x: 10)
                 
                 ImageFromUrl(peopleImages[1])
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 50, height: 50)
                     .clipShape(Circle())
                     .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                     .shadow(radius: 15)
                     .padding([.leading, .trailing])
                     .offset(x: 15)
                 
                 ImageFromUrl(peopleImages[0])
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 50, height: 50)
                     .clipShape(Circle())
                     .overlay(Circle().stroke(colors.randomElement() ?? .blue, lineWidth: 1))
                     .shadow(radius: 15)
                     .padding([.leading, .trailing])
                     .offset(x: 20)
                 
             }
         }

        */
            
          
            
        
        
        
    }
    
    /*
    func getAndLoadNotableUsersWithSamePlacement()  {
        
        guard let Planet = planet else {
            print("Guard statement failed planet is .. \(planet)")
            return
        }
        
        Account().notablesWithPlacement(planet: Planet) { error, users in
            
            
            otherNotableUsersWithAspect = users
        }
        
        /*
        // Getting Notable Users With This Sign
        Firestore.firestore()
            .collection("placements")
            .document(Planet.name.rawValue)
            .collection(Planet.sign.rawValue)
          // .whereField("isNotable", isEqualTo: true)
           .limit(to: 4)
            .getDocuments { snapshot, error in
                 
                
                var usersfromdatabase: [AmareUser] = []
                
                print("Getting documents.... \(Planet.name.rawValue) : \(Planet.sign.rawValue)")
                
                guard error == nil else {return}
                print("Error getting docs is ... \(error)")
                
                for document in snapshot!.documents{
                    
                    let doc = document.data()
                    let id = document.documentID
                    let is_notable = doc["is_notable"]
                    
                    print("FOUND FIT: the doc is ... \(doc)")
                    
                    Account().getOtherUser(from: id) { user, error in
                        
                        guard let user = user else {return}
                        
                        // Append user to the users of similar aspects
                        print("Adding to notable users")
                        usersfromdatabase.append(user)
                        print("now the usersfromdatabase is \(usersfromdatabase)")
                    }
                    
                    
                  
                }
                
                otherNotableUsersWithAspect = usersfromdatabase
                print("other notable users: \(otherNotableUsersWithAspect) and users from database: \(usersfromdatabase)")
            }
        
        */
    }
     */
    

}

struct MoreInfoOnPlanet_Previews: PreviewProvider {
    static var previews: some View {
        
        var p  = Planet(name: .Moon, angle: 21.3, element: .water, onCusp: false, retrograde: false, sign: .Scorpio, cusp: nil, speed: 23)
        
        MoreInfoOnPlanet(planet: p, exit: .constant(false)).preferredColorScheme(.dark)
    }
}


/*
import Combine

struct FadingTextView: View {
    
    @Binding var source: String
    var transitionTime: Double
    
    @State private var currentText: String? = nil
    @State private var visible: Bool = false
    private var publisher: AnyPublisher<[String.Element], Never> {
        source
            .publisher
            .collect()
            .eraseToAnyPublisher()
    }
    
    init(text: Binding<String>, totalTransitionTime: Double) {
        self._source = text
        self.transitionTime = totalTransitionTime / 3
    }
    
    private func update(_: Any) {
        guard currentText != nil else {
            currentText = source
            DispatchQueue.main.asyncAfter(deadline: .now() + (transitionTime)) {
                self.visible = true
            }
            return
        }
        guard source != currentText else { return }
        self.visible = false
        DispatchQueue.main.asyncAfter(deadline: .now() + (transitionTime)) {
            self.currentText = source
            DispatchQueue.main.asyncAfter(deadline: .now() + (transitionTime)) {
                self.visible = true
            }
        }
    }
    
    var body: some View {
        Text(currentText ?? "")
            .opacity(visible ? 1 : 0)
            .animation(.linear(duration: transitionTime))
            .onReceive(publisher, perform: update(_:))
    }
    
}


extension String {
    
    /// Converts some strings to Latin. Not all though. If we don't have a translation it'll just return empty string
    func latin() -> String {
        
        if self == "Moon"{
            return "Luna"
        }
        
        else {return ""}
    }
}
*/
