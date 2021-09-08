//
//  NatalChartView.swift
//  NatalChartView
//
//  Created by Micheal Bingham on 9/4/21.
//

import SwiftUI

/// Represents a natal chart
struct NatalChartView: View {
    
    /// Radius of the outer circle or frame size. Use to set the size of the natal chart, will default as `.infinity`
    var R: CGFloat  = .infinity
    
    /// Distance between outer and inner circles. (Out-most circle -- inner FRAME circle. Not the inner most circle where the ticks are)
    /// will also determine the size of the planet / sign symbols.
    var d: Double = 50 // was 45 in prior version 
    
    /// Wheel rotation , if > 0 clockwise rotation, otherwise counterclockwise rotation . Used for helping rotate natal chart.
    var alpha: Double = 0
    
    /// If nil, only the default wheel will be draw.
    var natalChart: NatalChart?
    
    /// Aspect to show, either all or one or none for now
    @State var aspectSelected:  AspectType = .all
        
        // [AspectType] = [.all]
   
    /// Distance from the inner FRAME (zodiac wheel) to the inner circle where the ticks are
    var distance_from_edge_of_frame_to_ticks = 50
    
    /// Whether or not to show or hide the aspects of the natal chart by default no
    var hideALLAspects: Bool = false
    
    /// Whether or not to show what aspects are being shown in the natal chart
    @State var showAspectLabel: Bool = false
    
    /// Whether or not the user selected a planet and more information should be shown
    @State var planetSelected: Planet?
    
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

                                    
                                    SignCuspLineView(from: pointAtInnerCircle, to: pointAtOuterCircle)
                                    
                                
                                    
                              
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
                                    
                                        
                                        
                                    
                                    
                                    
                                }
                                
                                
                                let circle_radius_where_ticks_are_at = Int(r)-distance_from_edge_of_frame_to_ticks
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
                                //var dr = 15
                                ForEach(all_angle_bodies){ angleBody in
                                    
                                
                                    
                                    let sign = angleBody.sign
                                    let deg = angleBody.angle
                                    
                                    /// Angle relative to aries 0 deg
                                    let relative_deg = deg + sign.beginsAt()
                                    
                                    
                                    
                                    
                                    // tick to put where the angle is
                                    Tick(x_center: Double(x_center), y_center: Double(y_center), radius_of_ticks: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                        
                                    
                                    let pos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at) + Double(10*Int.random(in: 1...4)), theta: relative_deg)
                                    
                                    // Planet Symbol should go here
                                    angleBody.image()
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
                                        .colorInvert()
                                        .rotationEffect(.degrees(-alpha))
                                        .position(pos)
                                        .onAppear(perform: {
                                            // TODO: Need so save AngleBody / pos somehow to retrieve later
                                            //   save(name_of_body: angleBody.name.string(), point: pos)
                                           //    savedBodies[angleBody.name.string()] = pos
                                             
                                            let tickPos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                            
                                            save(name_of_body: angleBody.name.rawValue, point: tickPos)
                                        })
                                        
                                        
                                    
                                }
                                
                                // Draws the Planets (Sun, Moon, etc..)
                                
                                let planets = natalChart?.planets ?? []
                                
                                ForEach(planets){ planet in
                                    
                                    let sign = planet.sign
                                    let deg = planet.angle
                                    
                                    /// Angle relative to aries 0 deg
                                    let relative_deg = deg + sign.beginsAt()
                                    
                            
                                    
                                    // tick to put where the planet is
                                    Tick(x_center: Double(x_center), y_center: Double(y_center), radius_of_ticks: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                    
                                    
                                    let pos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at)+Double(10*Int.random(in: 1...4)), theta: relative_deg)
                                    // Planet Symbol should go here
                                    
                                    
                                    
                                    planet.image()
                                        //.buttonStyle(.default)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
                                        .colorInvert()
                                        .rotationEffect(.degrees(-alpha))
                                        .position(pos)
                                        .onAppear(perform:{
                                            
                                            let tickPos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                                            
                                            save(name_of_body: planet.name.rawValue, point: tickPos)
                                        })
                                        .onTapGesture{
                                            print("Planet selected: \(planet)")
                                            planetSelected = planet
                                        }
                                        .zIndex(1)
                                    
                                    
                                   
                                    
                                
                                    // TODO: Need so save Planet / pos somehow to retrieve later.. i think i did this already
                                        
                                    
                                }
                                
                                
                                
                                // Draws the Aspects
                                
                               
                                
                                let aspects = natalChart?.aspects ?? []
                                
                                ZStack{
                                    
                                    ForEach(aspects){ aspect in
                                        
                                        AspectView(aspect: aspect, type_to_show: aspectSelected ?? .all)
                                            .opacity(hideALLAspects ? 0: 1)
                                           
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
               /* .contextMenu{
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

                    
                } */

        
               
            
                
            
                
            
            
        
        
            
    }
    
    func PlanetView(planet: Planet, pos: CGPoint, x_center: CGFloat, y_center: CGFloat, circle_radius_where_ticks_are_at: CGFloat, relative_deg: Double) -> some View {
        
        planet.image()
            // .buttonStyle(.default)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
            .colorInvert()
            .rotationEffect(.degrees(-alpha))
            .position(pos)
            .onAppear(perform:{
                
                let tickPos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(circle_radius_where_ticks_are_at), theta: relative_deg)
                
                save(name_of_body: planet.name.rawValue, point: tickPos)
            })
            .onTapGesture{
                print("Planet selected: \(planet)")
            }
            .zIndex(1)
    }
    
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
    func polar(x_center: Double, y_center: Double, r: Double, theta: Double) -> CGPoint {
        
        let delx = r*cos(theta.toRadians())
        let newx = x_center + delx
        
        let dely = r*sin(theta.toRadians())
        let newy = y_center - dely
        
        let point = CGPoint(x: newx, y: newy )
        
       
        return point
        
        
       
        
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
   
}




struct SignCuspLineView: View {
    
    let from: CGPoint
    let to: CGPoint
    
    var body: some View {
        
       // ForEach(0...11, id: \.self){
       //       var n = $0
      
              
             // let pointAtInnerCircle = CGPoint(x: x_center + r*cos((30*n).toRadians()), y: y_center - r*sin((30*n).toRadians()))
              
         //     let pointAtOuterCircle = CGPoint(x: x_center + R_*cos((30*n).toRadians()), y: y_center - R_*sin((30*n).toRadians()))
              
              // Draws the cusps (lines/bordes)
              Path{ path in
                  
                  path.move(to: from)
                  path.addLine(to: to)
              }
              .stroke()
              
              
        //  }
    }
}

struct AspectView: View {
    
    let aspect: Aspect
    let type_to_show: AspectType //= [.all]

    
    var body: some View{
        ZStack{
            
            let firstPlanet = aspect.first
            let secondPlanet = aspect.second
            
            let loc1 = pointFor(planet: firstPlanet.rawValue)
            let loc2 = pointFor(planet: secondPlanet.rawValue)
            
           
            // It's a trine .. .
            Path{ path in
                
                path.move(to: loc1)
                path.addLine(to: loc2)
            }
            .stroke()
            .opacity(type_to_show == aspect.type || type_to_show ==  .all ? 1 : 0  )
            
            //.opacity( ( (type_to_show == (aspect.type) && type_to_show  != .nothing) ) || (type_to_show == .all) && aspect.type != .none && type_to_show != .nothing ? 1 : 0)
            
            
        }
        
    }
    
    /// Returns the point that the planet or angle (asc/desc/etc) ended up on the view
    /// If it's (0,0) it should be ignored
    func pointFor(planet: String) -> CGPoint {
        let point = NSCoder.cgPoint(for: UserDefaults.standard.object(forKey: planet) as? String ?? "{0,0}" )
            //   print("Trying to get point for \(planet) and got \(point) ")
        return point
    }
}


/// Rotates the zodiac wheel
struct Rotate: AnimatableModifier {
    /// Degrees clockwise to rotate the wheel. Negative angle -> counter clockwise.
    var degrees: Double = 0
    
    var animatableData: Double {
            get     { degrees }
            set { degrees = newValue }
        }
    /// here is probably the issue why you can't use more than one modifier // TODO; 
    func body(content: Content) -> some View {
        return NatalChartView(alpha: degrees)
    }
    
}

/// Adjusts the spacing of the outer frame
struct FrameSpacing: AnimatableModifier {
    
    var distance: Double = 45
    
    var animatableData: Double {
            get     { distance }
            set { distance = newValue }
        }
    
    func body(content: Content) -> some View {
        return NatalChartView(d: distance)
    }
}

/// Radius of the outer wheel
struct Radius: AnimatableModifier {
    
    var radius: CGFloat = .infinity
    
    var animatableData: CGFloat {
            get     { radius }
            set { radius = newValue }
        }
    
    func body(content: Content) -> some View {
        return NatalChartView(R: radius)
    }
}

/// Creates the natal chart given a `NatalChart`
struct Make: AnimatableModifier{
    
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
            
            
            
            return NatalChartView(alpha: -1*rotation_offset, natalChart: with, aspectSelected: aspectSelected ?? .all)
                //.rotate(degrees: rotation_offset )
        }
        /// - WARNING: setting alpha to -180 by default here will cancel spin annimation on initalization if ascendant is not given
        return NatalChartView( alpha: -180, natalChart: with,aspectSelected: aspectSelected ?? .all )
        
    }
}


extension View{
    /// Rotates the view clockwise. If negative, counterclockwise.
    func rotate(degrees: Double) -> some View {
        modifier(Rotate(degrees: degrees))
    }
    
    /// Adjusts the spacing of the outer frame, or the length of the sign borders
    func frameSpacing(distance: Double) -> some View {
        modifier(FrameSpacing(distance: distance))
    }
    
    /// Sets the radius of the outer wheel
    func radius(radius: CGFloat) -> some View {
        modifier(Radius(radius: radius))
    }
    
    /// Sets the natal chart data and rotates chart based on ascendant 
    func make(with: NatalChart?, shownAspect: AspectType? = .all) -> some View {
        modifier(Make(with: with, aspectSelected:  shownAspect))
    }
}


struct Tick: View {
    
    /// relative center of view to use as (0,0) for polar coordinates. Should just be the center of that view
    let x_center: Double
    let y_center: Double
    
    // R
    let radius_of_ticks: Double
    
    //Theta
    let theta: Double
    
    // length of tick
    let length: Double = 3
    
    var body: some View{
        
      
        let one_end = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(radius_of_ticks), theta: theta)
        let other_end = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(radius_of_ticks)-length, theta: theta)
        
    
        Path{ path in
            
            path.move(to: one_end)
            path.addLine(to: other_end)
        }
        .stroke()
    }
    
    /// Get's the Radius (R),  angle, and reference for (x,y) center and returns the CGPoint using polar representation
    func polar(x_center: Double, y_center: Double, r: Double, theta: Double) -> CGPoint {
        
        let delx = r*cos(theta.toRadians())
        let newx = x_center + delx
        
        let dely = r*sin(theta.toRadians())
        let newy = y_center - dely
        
        let point = CGPoint(x: newx, y: newy )
        
       
        return point
        
        
       
        
    }
}


struct NatalChartView_Previews: PreviewProvider {
    static var previews: some View {
        NatalChartView()
            .preferredColorScheme(.dark)
    }
}
extension Double{
    func toRadians() -> Double {
        return NatalChartView().deg2rad(self)
    }
}

extension Int{
    func toRadians() -> Double {
        return NatalChartView().deg2rad( Double(self) )
    }
}

extension CGPoint {
  func midpoint(with: CGPoint) -> CGPoint {
      let delx = self.x + with.x
      let newx = delx / 2
      
      let dely = self.y + with.y
      let newy = dely / 2
      
      return CGPoint(x: newx, y: newy)
  }
}
