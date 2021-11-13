//
//  MoreInfoOnGenericPlanet.swift
//  Amare
//
//  Created by Micheal Bingham on 10/3/21.
//

import SwiftUI

struct MoreInfoOnGenericPlanet: View {
    
    var planet: Planet?
    
    // For the fade animation of the keywords of what it rules over
    @State var control2: Bool = false
    @State var counter2 = 0
    @State var keyword: String = ""{
        didSet{
            control2.toggle()
        }
    }
    
    @State var control: Bool = false
    
    @State var nameOfPlanet: String = "" {
        didSet{
            control.toggle()
        }
    }
    // For alternating between latin and english
    @State var counter = 0
    
    // What the planet rules
   // var keywords = planet?.name.keywords() ?? [""]

    
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
                    Text("At Home in")
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
    func atHomeIn() -> some View {
        
        var name_of_house = planet?.name.houseRuler()?.rawValue ?? HouseNameOrd.allCases.randomElement()!.rawValue
      
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
        
        let timer = Timer.publish(every: 3, on: .main, in: .default).autoconnect()
        
        var planetName = planet?.name ??  PlanetName.allCases.randomElement()!
        
    
       return Text(nameOfPlanet)
            .font(.largeTitle)
             .bold()
             .modifier(FadeModifier(control: control))
           
             // Duration of the fade animation
             // .animation(.easeInOut(duration: 2))
             .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
            .onReceive(timer) { _ in
                
                //TODO: these should not animate at same time
               
                if counter % 2 != 0 {
                    withAnimation {
                    
                        //TODO: should not be random element
                        keyword = planet?.name.keywords().randomElement()! ?? ""
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
                       keyword =  planet?.name.keywords().randomElement()! ?? ""

                        nameOfPlanet = planetName.rawValue.latin()

                        
                       /* AmareApp().delay(1) {
                            withAnimation {
                                nameOfPlanet = planetName.rawValue.latin()

                            }
                            
                        }*/
                        

                    }
                    
                }
                
                counter += 1
                
            }
            .onAppear {
                nameOfPlanet = planetName.rawValue
            }
        
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
        
        
        
        return Text(keyword)
             .font(.largeTitle)
              .bold()
              .frame(maxWidth : .infinity, alignment: .center)
           // .padding()
             .foregroundColor(Color.primary.opacity(0.4))
              .modifier(FadeModifier(control: control2))
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
                 keyword = planet?.name.keywords()[0] ?? "Not Known"
             }
             
    }
    
    
    
    

}

struct MoreInfoOnGenericPlanet_Previews: PreviewProvider {
    static var previews: some View {
        
        var p  = Planet(name: .Moon, angle: 21.3, element: .water, onCusp: false, retrograde: false, sign: .Cancer, cusp: nil, speed: 23)
        
        MoreInfoOnGenericPlanet(planet: p).preferredColorScheme(.dark)
    }
}


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
        
        else {return self }
    }
}
