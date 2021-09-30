//
//  SmallNatalChartView.swift
//  Amare
//
//  Created by Micheal Bingham on 9/30/21.
//

import SwiftUI

/// Represents a natal chart
struct SmallNatalChartView: View {
    
    /// Radius of the outer circle or frame size. Use to set the size of the natal chart, will default as `.infinity`
    var R: CGFloat  = 75
    
    /// Distance between outer and inner circles. (Out-most circle -- inner FRAME circle. Not the inner most circle where the ticks are)
    /// will also determine the size of the planet / sign symbols.
    var d: Double = 20 // was 45 in prior version
    
    /// Wheel rotation , if > 0 clockwise rotation, otherwise counterclockwise rotation . Used for helping rotate natal chart.
    var alpha: Double = 0
    
    /// If nil, only the default wheel will be draw.
    var natalChart: NatalChart?

    
    /// Aspect to show, either all or one or none for now
    @State var aspectSelected:  AspectType = .all
        
        // [AspectType] = [.all]
   
    /// Distance from the inner FRAME (zodiac wheel) to the inner circle where the ticks are
    @State var distance_from_edge_of_frame_to_ticks = 20
    
    /// Whether or not to show or hide the aspects of the natal chart by default no
    var hideALLAspects: Bool = false
    
    /// Whether or not to show what aspects are being shown in the natal chart
    @State var showAspectLabel: Bool = false
    
    /// Whether or not the user selected a planet and more information should be shown
    @State var planetSelected: Planet?
    
    @State var showHouses: Bool = true
    
    @State var showBottomPopup: Bool = false
    
   // @State var aspectSelected: AspectType?
    
    var body: some View {
        
    
                ZStack{
                    
                    // Outer Wheel
                        Circle()
                            .stroke()
                            .frame(width: (R != .infinity) ? CGFloat(2*R): .infinity, height: (R != .infinity) ? CGFloat(2*R): .infinity)
                            
                           
                    
                    GeometryReader{ outerCircleGeometry in
                        
                        /// Center points of the outer circle
                        let x_center = outerCircleGeometry.frame(in: .local).midX
                        /// Center of the outmost circle frame
                        let y_center = outerCircleGeometry.frame(in: .local).midY
                        
                        
                        ZStack{
                            
                            GeometryReader { innerCircleGeometry in
                                
                                ////  Radius of inner FRAME
                                let r = (innerCircleGeometry.size.width)/2
                                
                                /// Radius of the outer circle frame. We use R_ instead of R_   because there is a chance that  `R` may be `.infinity`
                                let R_ = outerCircleGeometry.size.width / 2
                                
                                
                                
                                //  Inner Wheel (FRAME) NOT the inner wheel where ticks are
                                Circle()
                                   .stroke()
                                   .frame(width: outerCircleGeometry.size.width - CGFloat(d), height: outerCircleGeometry.size.height - CGFloat(d))
                                   .position(x: x_center, y: y_center)
                                    
                                    
                                
                                // Draws the Natal Chart Wheel Frame
                             // Draws the
                                ForEach(0..<12){ n in
                                    //let n = $0
                                    let n2 = n+1
                                    
                                    let theta = Double(30*n)
                                    /// Inner circle of the FRAME
                                    let pointAtInnerCircle = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(r), theta: theta)
                                    /// outer circle of the FRAME
                                    let pointAtOuterCircle = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(R_), theta: theta)

                                    
                                    Line(from: pointAtInnerCircle, to: pointAtOuterCircle)
                                    
                                
                                    
                              
                                   // Zodiac Symbols // ......
                                    // Coordinates for the sign symbols on the wheel
                                    /// Angle to put zodiac signs
                                    let phi = Double(15 + (30*n))
                                    /// Radius to put zodiac signs
                                    let r_prime =  (r+R_)/2
                                    
                                    let pointToPlace = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(r_prime), theta: phi)
                                    
                                    let sign = ZODIAC_SIGNS[n2-1]
                                    
                                    
                                     sign.image()
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
                                        .colorInvert()
                                        .rotationEffect(.degrees(-1*alpha))
                                        .position(x: pointToPlace.x, y: pointToPlace.y)
                                        .onTapGesture{
                                            print("Sign selected \(sign)")
                                            NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: sign)
                                            
                                        }
                                    
                                        
                                        
                                    
                                    
                                    
                                }
                                
                                
                            
                                
                                var circle_radius_where_ticks_are_at = ( natalChart?.synastryPlanets == nil )  ? Int(r)-distance_from_edge_of_frame_to_ticks : (Int(r)-distance_from_edge_of_frame_to_ticks) / 2
                                
                                
                                // Draws the degree ticks/points
                                ForEach(0 ..< 360) { deg in
                                    
                                    
                        
                                    
                                    let location = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: Double(deg))
                                    
                                    Text(" ∙ ")
                                        .position(location)
                                       
                                   
                                    
                                }
                                
                                /*
                                Circle()

                                    .foregroundColor(.black.opacity(0.0001))
                                     .frame(width: CGFloat(2*circle_radius_where_ticks_are_at), height: CGFloat(2*circle_radius_where_ticks_are_at))
                                     .position(x: CGFloat(Double(x_center)), y: CGFloat(Double(y_center)))
                                    .contextMenu{
                                        Button {
                                            //style = 0
                                        } label: {
                                            Text("Linear")
                                            Image(systemName: "arrow.down.right.circle")
                                        }
                                        Button {
                                            //style = 1
                                        } label: {
                                            Text("Radial")
                                            Image(systemName: "arrow.up.and.down.circle")
                                        }

                                        
                                    }
                                
                                */
 
                                
                              
                                
                                Text((aspectSelected ?? .all).toString())
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(-1*alpha))
                                    .position(x: CGFloat(Double(x_center)), y: CGFloat(Double(y_center)))
                                    .opacity(showAspectLabel ? 1 : 0 )
                                
                                
                                
                                // Draws the Angles (Asc, MC, etc..)
                                let all_angle_bodies = natalChart?.angles ?? []
                                
                                var synastryAngles = (natalChart?.synastryAngles ?? [])
                                
                            var allAnglesWSyn  = all_angle_bodies + synastryAngles
                                
                                
                              
                                
                                //var dr = 15
                                ForEach(allAnglesWSyn){ angleBody in
                                    
                                
                                    
                                    let sign = angleBody.sign
                                    let deg = angleBody.angle
                                    
                                    /// Angle relative to aries 0 deg
                                    let relative_deg = deg + sign.beginsAt()
                                    
                                    
                                    
                                    
                                    // tick to put where the angle is
                                    Tick(x_center: Double(x_center), y_center: Double(y_center), radius_of_ticks: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                        
                                    
                                    let pos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at) + Double(10*Int.random(in: 1...4)), theta: relative_deg, forAngleBody: angleBody)
                                    
                                 //   let correctedPos: CGPoint = pos.correctFor(angle: angleBody, center: CGPoint(x: x_center, y: y_center) )
                                    
                                    // Planet Symbol should go here
                                    angleBody.smallerImage()
                                        .rotationEffect(.degrees(-alpha))
                                        .position(pos)
                                        .onAppear(perform: {
                                            // TODO: Need so save AngleBody / pos somehow to retrieve later
                                            //   save(name_of_body: angleBody.name.string(), point: pos)
                                           //    savedBodies[angleBody.name.string()] = pos
                                             
                                            let tickPos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                            
                                            save(name_of_body: angleBody.name.rawValue, point: tickPos)
                                        })
                                        .onTapGesture{
                                            print("angle selected \(angleBody)")
                                            NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: angleBody)
                                        }
                                        
                                        
                                    
                                }
                                
                                // Draws the Planets (Sun, Moon, etc..)
                                
                                
                                var planets = (natalChart?.planets ?? [])
                                var synastryPlanets = (natalChart?.synastryPlanets ?? [])
                                
                            var allPlanets  = planets + synastryPlanets
                                
                                ForEach(allPlanets){ planet in
                                    
                                    let sign = planet.sign
                                    let deg = planet.angle
                                    
                                    /// Angle relative to aries 0 deg
                                    let relative_deg = deg + sign.beginsAt()
                                    
                            
                                    
                                    // tick to put where the planet is
                                    Tick(x_center: Double(x_center), y_center: Double(y_center), radius_of_ticks: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                    
                                    
                                    let pos: CGPoint = polar(x_center: Double(x_center), y_center: Double(y_center), r:  Double(circle_radius_where_ticks_are_at)+Double(5*Int.random(in: 1...4)), theta: relative_deg)
                                    
                                   
                                    let correctedPos: CGPoint = pos.correct(planet: planet, center: CGPoint(x: x_center, y: y_center) )
                                    
                                    
                                    
                                    planet.image(size: d)
                                        .rotationEffect(.degrees(-alpha))
                                        .position(correctedPos)
                                     
                                        .onAppear(perform:{
                                            
                                            guard !(planet.forSynastry ?? false) else {return}
                                            
                                            // If it's a part of the inner person's natal chart
                                            
                                            let tickPos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                            
                                            save(name_of_body: planet.name.rawValue, point: tickPos)
                                            
                                            
                                           
                                            
                                        })
                                        .onTapGesture{
                                            print("Planet selected: \(planet)")
                                       NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: planet)
                                        }
                                        .zIndex(1)
                                    
                                    
                                   
                                    
                                
                                    // TODO: Need so save Planet / pos somehow to retrieve later.. i think i did this already
                                       
                                    
                                }
                                
                                /*
                                let synastryPlanets = natalChart?.synastryPlanets ?? []
                                ForEach(synastryPlanets) {
                                    
                                    
                                } */
                                
                                HouseDividers(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), R_: Double(r))
                                    .opacity(showHouses ? 0.5: 0 )
                                    .zIndex(0)
                                
                                
                                // Draws the Aspects
                                
                               
                                
                                let aspects = natalChart?.aspects ?? []
                                
                                ZStack{
                                    
                                    ForEach(aspects){ aspect in
                                        
                                        AspectView(aspect: aspect, type_to_show: aspectSelected ?? .all)
                                            .opacity((hideALLAspects || natalChart?.synastryPlanets != nil) ? 0: 1)
                                           
                                    }
                                }
                                .contentShape( Circle()
                                                /*
                                                 .frame(width: CGFloat(2*circle_radius_where_ticks_are_at), height: CGFloat(2*circle_radius_where_ticks_are_at))*/)
                                .contextMenu{
                                    
                                    Menu("Aspects") {
                                        
                                       
                                        
                                        
                                        Picker("Chosen", selection: $aspectSelected){
                                            
                                            var options = AspectType.options()
                                            
                                            ForEach(options, id: \.self){ aspect in
                                                
                                                Text(aspect.localizedName)
                                                    .tag(aspect)
                                            }
                                            
                                        
                                            
                                        }
                                    }

                                    
                                    Menu("Houses") {
                                        
                                        Picker("Houses", selection: $showHouses){
                                            
                                            Text("Show Houses").tag(true)
                                            Text("Hide Houses").tag(false)
                                        }
                                    }
                                }
                                
                                
                                
                                /*
                                 
                                 
                                .onTapGesture {
                                    print("Did click and should change aspects ")
                                    
                                    aspectSelected = .trine
                                                                        
                                                                       showAspectLabel = true
                                                                        
                                                                        AmareApp().delay(3) {
                                                                            showAspectLabel = false
                                                                        }
                                } */
                                
                               
                                
                                
                            }
                            
                            
                          
                        }.frame(width: outerCircleGeometry.size.width - CGFloat(d), height: outerCircleGeometry.size.height - CGFloat(d))
                        
                        
                        
                        
                        
                        
                        
                            
                           
                    }
                        
                    
                    
                }.frame(width: (R != .infinity) ? CGFloat(2*R): .infinity, height: (R != .infinity) ? CGFloat(2*R): .infinity)
                .rotationEffect(.degrees(alpha))
              
              
             
        
               
            
                
            
                
        
            
        
        
            
    }
    
    func HouseDividers(x_center: Double, y_center: Double, r: Double, R_: Double) -> some View {
        let houses = self.natalChart?.houses ?? []
        
        return  ZStack{
                
               ForEach(houses) { house in
                
                // Draw house divider
                
                let sign = house.sign
                let angle = house.angle
                
                let relative_deg = angle + sign.beginsAt()
                
                
                
                
                let sp: CGPoint = polar(x_center: x_center, y_center: y_center, r: r, theta: relative_deg)
                
                let ep: CGPoint = polar(x_center: x_center, y_center: y_center, r: R_, theta: relative_deg)
                
                let offset = (house.size*0.5)
                
                let sp2: CGPoint = polar(x_center: x_center, y_center: y_center, r: r, theta: relative_deg + offset)
                
                let ep2: CGPoint = polar(x_center: x_center, y_center: y_center, r: R_, theta: relative_deg + offset )
                
                
                
              //  let r_mid = 0.5*r*R_
                let r__ : CGPoint = sp2.midpoint(with: ep2)
                
              //  let theta_mid = ((house.size)/2) + relative_deg
                
            //    var midpoint_between_houses: CGPoint = polar(x_center: x_center, y_center: y_center, r: r_mid, theta: Double(theta_mid))
                
                
                
                Text("\(house.ordinality)")
                    .rotationEffect(.degrees(-alpha))
                    .position(r__)
                    .onTapGesture{
                        print("House selected \(house)")
                          NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: house)

                    }

                
                
                Line(from: sp, to: ep)
              //  Line(from: sp2, to: ep2).foregroundColor(.black)

               
                
            }
                
    }
            

    }
    /*
    func planetView(planet: Planet, d: Double, pos: CGPoint, x_center: Double, y_center: Double, circle_radius_where_ticks_are_at: Double, relative_deg: Double) -> some View {
        
        return  planet.image(size: d)
            //.buttonStyle(.default)
           //.resizable()
         //   .aspectRatio(contentMode: .fit)
            //  .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
            .colorInvert()
            .rotationEffect(.degrees(-alpha))
            .position(pos)
            .onAppear(perform:{
                
                guard !(planet.forSynastry ?? false) else {return}
                
                // If it's a part of the inner person's natal chart
                
                let tickPos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                
                save(name_of_body: planet.name.rawValue, point: tickPos)
                
                
               
                
            })
            .onTapGesture{
                print("Planet selected: \(planet)")
           NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: planet)
            }
            .zIndex(1)
    } */
    /*
    func PlanetView(planet: Planet, pos: CGPoint, x_center: CGFloat, y_center: CGFloat, circle_radius_where_ticks_are_at: CGFloat, relative_deg: Double) -> some View {
        let sign = planet.sign
        let deg = planet.angle
        
        /// Angle relative to aries 0 deg
        let relative_deg = deg + sign.beginsAt()
        

        
        // tick to put where the planet is
        Tick(x_center: Double(x_center), y_center: Double(y_center), radius_of_ticks: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
        
        
        let pos: CGPoint = polar(x_center: Double(x_center), y_center: Double(y_center), r:  Double(circle_radius_where_ticks_are_at)+Double(10*Int.random(in: 1...4)), theta: relative_deg)
        
       // let pos2 = polar(x_center: Double(x_center), y_center: Double(y_center), r:  Double(circle_radius_where_ticks_are_at)+Double(10*Int.random(in: 1...4)), theta: relative_deg)
        
      //  var radForSyn: Double = Double(circle_radius_where_ticks_are_at)*2.0
        
    //    let pos2 = polar(x_center: Double(x_center), y_center: Double(y_center), r:  radForSyn+Double(10*Int.random(in: 1...4)), theta: relative_deg)
        
        //let posIfPlanetForSynastry = polar(x_center: Double(x_center), y_center: Double(y_center), r:  Double(circle_radius_where_ticks_are_at)+Double(10*Int.random(in: 1...4)), theta: relative_deg)
        // Planet Symbol should go here
        
      //  var x_offset = 5
      //  var y_offset = 5
        
        
       return  planet.image()
            //.buttonStyle(.default)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
            .colorInvert()
            .rotationEffect(.degrees(-alpha))
            .position(pos)
            .onAppear(perform:{
                
                guard !(planet.forSynastry ?? false) else {return}
                
                // If it's a part of the inner person's natal chart
                
                let tickPos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                
                save(name_of_body: planet.name.rawValue, point: tickPos)
                
                
               
                
            })
            .onTapGesture{
                print("Planet selected: \(planet)")
           NotificationCenter.default.post(name: NSNotification.wantsMoreInfoFromNatalChart, object: planet)
            }
            .zIndex(1)
        
        
       
        
    
        // TODO: Need so save Planet / pos somehow to retrieve later.. i think i did this already
    }
    */
    
    /// Given an array of aspect types, it returns a string representing the aspects given in this array
    /// - example: aspects = [.trine, .square] -> "Trines and Squares"
    /// -TODO: error for quincunx
    func aspectsBeingShown(aspects: [AspectType]) -> String {
        
        if aspects.count == 1 {
            
            if aspects.first == .all{
                return "Intra-aspects"
            }
            
            if aspects.first == .quincunx {return "Quincunxes"}
            
            else if aspects.first == .nothing || aspects.first == AspectType.none {
                return ""
            }
            
            else {
                return "\(aspects.first?.rawValue.capitalized ?? "")s"
            }
        }
         
        else {
            // there's more than one in the array ...
            
            if aspects.contains(.all) { return "Intra-aspects"}
            else if aspects.contains(.nothing) || aspects.contains(.none) {return ""}
            
            var words: [String] = []
            for aspect in aspects {
                
                words.append(aspectsBeingShown(aspects: [aspect]))
                
            }
            
            
            return words.joined(separator: "\n")
            
        }
        //return "\(aspects.first?.rawValue ?? "")"
        
    }
    
     func save(name_of_body: String, point: CGPoint)  {
        let pt = NSCoder.string(for: point)
     //   print("Saving .. \(name_of_body) at \(pt)" )
        UserDefaults.standard.setValue(pt, forKey: name_of_body)
    }
    
    /// Returns the point that the planet or angle (asc/desc/etc) ended up on the view
    /// If it's (0,0) it should be ignored
    func pointFor(planet: String) -> CGPoint {
        return NSCoder.cgPoint(for: UserDefaults.standard.object(forKey: planet) as? String ?? "{0,0}" )
    }
    
    /// Get's the Radius (R),  angle, and reference for (x,y) center and returns the CGPoint using polar representation
    func polar(x_center: Double, y_center: Double, r: Double, theta: Double, forAngleBody: Angle? = nil) -> CGPoint {
        
        let delx = r*cos(theta.toRadians())
        let newx = x_center + delx
        
        let dely = r*sin(theta.toRadians())
        let newy = y_center - dely
        
        let point = CGPoint(x: newx, y: newy )
        
        if let angle = forAngleBody{
            if angle.forSynastry ?? false{
                
                let sign = angle.sign
                let deg = angle.angle
                print("\(angle) for synastry \(sign) and \(deg)")
                /// Angle relative to aries 0 deg
                let relative_deg = deg + sign.beginsAt()
                
                
                print("relative deg is .. \(relative_deg)")
                var center = CGPoint(x: CGFloat(x_center), y: CGFloat(y_center))
                
                return polar(x_center: x_center, y_center: y_center, r: r, theta: relative_deg).moveAwayFrom(centerPoint: center, theta: relative_deg, by: 55)
                    
                    //point.moveAwayFrom(centerPoint: center, theta: theta, by: 50)
            }
        }
        
       
        return point
        
        
       
        
    }
    
    func polar2(x_center: Double, y_center: Double, r: Double, theta: Double) -> (CGPoint, CGPoint) {
        
        let delx = r*cos(theta.toRadians())
        let newx = x_center + delx
        
        let dely = r*sin(theta.toRadians())
        let newy = y_center - dely
        
        let point = CGPoint(x: newx, y: newy )
        
        
        let delx2 = 2*r*cos(theta.toRadians())
        let newx2 = x_center + delx
        
        let dely2 = 2*r*sin(theta.toRadians())
        let newy2 = y_center - dely
        
        let point2 = CGPoint(x: newx, y: newy )
       
        return (point, point2)
        
        
       
        
    }
    
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
   
}


/// Creates the natal chart given a `NatalChart`
struct MakeSmall: AnimatableModifier{
    
    var with: NatalChart?
    var aspectSelected: AspectType?
    
    
    var animatableData: NatalChart? {
            get     { with }
            set { with = newValue }
        }
    
    func body(content: Content) -> some View {
        
        // Should get the ascendant
        if let asc = with?.angles.get(planet: .asc) {
            // There is an ascendant provided
            // Correct Natal Chart to put ascendant at the left side, theta = 180
            
            // To Correct Ascendant Position
            // Using 0 deg aries as theta = 0.
            // Ascendent will be located at theta_prime, relative to aries
            // Rotate by 180-theta_prime counter clockwise
            // theta_prime = angle the sign is in + deg sign starts at (relative to aries)
            
      
            
            let theta_prime = asc.angle + asc.sign.beginsAt()
            let rotation_offset = 180 - theta_prime
            
            
            
            return SmallNatalChartView(alpha: -1*rotation_offset, natalChart: with, aspectSelected: aspectSelected ?? .all)
                //.rotate(degrees: rotation_offset )
        }
        /// - WARNING: setting alpha to -180 by default here will cancel spin annimation n initalization if ascendant is not given
        return SmallNatalChartView( alpha: -180, natalChart: with,aspectSelected: aspectSelected ?? .all )
        
    }
}


extension View{
    
    /// Sets the natal chart data and rotates chart based on ascendant. Makes the smaller version of the natal chart
    func makeSmall(with: NatalChart?, shownAspect: AspectType? = .all) -> some View {
        modifier(MakeSmall(with: with, aspectSelected:  shownAspect))
    }
}


struct SmallNatalChartView_Previews: PreviewProvider {
    static var previews: some View {
        SmallNatalChartView()
            .preferredColorScheme(.dark)
    }
}
