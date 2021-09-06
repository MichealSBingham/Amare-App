//
//  NatalChartView.swift
//  NatalChartView
//
//  Created by Micheal Bingham on 9/4/21.
//

import SwiftUI

struct NatalChartView: View {
    
    /// Radius of the outer circle or frame size.
    var R: CGFloat  = .infinity
    
    /// Distance between outer and inner circles . (R - r = d) --> r = R - d or
    var d: Double = 45
    
    /// Wheel rotation , if > 0 clockwise rotation, otherwise counterclockwise rotation . Used for helping rotate natal chart
    var alpha: Double = 0
    
    var natalChart: NatalChart?
    
    var body: some View {
        
    
                ZStack{
                    
                    // Outer Wheel
                        Circle()
                            .stroke()
                            .frame(width: (R != .infinity) ? CGFloat(2*R): .infinity, height: (R != .infinity) ? CGFloat(2*R): .infinity)
                           
                    
                    GeometryReader{ outerCircleGeometry in
                        
                        /// Center points of the outer circle
                        let x_center = outerCircleGeometry.frame(in: .local).midX
                        let y_center = outerCircleGeometry.frame(in: .local).midY
                        
                        
                        ZStack{
                            
                            GeometryReader { innerCircleGeometry in
                                
                                //// Radius of the inner circle both the width and the height
                                let r = (innerCircleGeometry.size.width)/2
                                
                                /// Radius of the outer circle. We use R_ instead of R_   because there is a chance that  `R` may be `.infinity`
                                let R_ = outerCircleGeometry.size.width / 2
                                
                                
                                
                                //  Inner Wheel
                                Circle()
                                   .stroke()
                                   .frame(width: outerCircleGeometry.size.width - CGFloat(d), height: outerCircleGeometry.size.height - CGFloat(d))
                                   .position(x: x_center, y: y_center)
                                
                                //var points: [CGPoint] = []
                                
                             
                                ForEach(0..<12){ n in
                                    //let n = $0
                                    let n2 = n+1
                                    
                                    let theta = Double(30*n)
                                    
                                    let pointAtInnerCircle = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(r), theta: theta)
                                    
                                    let pointAtOuterCircle = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(R_), theta: theta)

                                    
                                    SignCuspLineView(from: pointAtInnerCircle, to: pointAtOuterCircle)
                                    
                                
                                    
                              
                                   // Zodiac Symbols // ......
                                    // Coordinates for the sign symbols on the wheel
                                    let phi = Double(15 + (30*n))
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
                                
                                
                                let radius_of_ticks = r-15
                                // Draw the degree ticks/points
                                ForEach(0 ..< 360) { deg in
                                    
                                    
                        
                                    
                                    let location = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(radius_of_ticks), theta: Double(deg))
                                    
                                    Text(" ∙ ")
                                        .position(location)
                                       

                                        
                                    
                                   
                                    
                                }
                                
                                
                                
                                // Draws the Angles (Asc, MC, etc..)
                                let all_angle_bodies = natalChart?.angles ?? []
                                //var dr = 15
                                ForEach(all_angle_bodies){ angleBody in
                                    
                                
                                    
                                    let sign = angleBody.sign
                                    let deg = angleBody.angle
                                    
                                    /// Angle relative to aries 0 deg
                                    let relative_deg = deg + sign.beginsAt()
                                    
                                    
                                    
                                    
                                    // tick to put where the angle is
                                    Tick(x_center: Double(x_center), y_center: Double(y_center), radius_of_ticks: Double(radius_of_ticks), theta: relative_deg)
                                        
                                    
                                    let pos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(radius_of_ticks) - Double(10*Int.random(in: 1...5)), theta: relative_deg)
                                    
                                    // Planet Symbol should go here
                                    angleBody.image()
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
                                        .colorInvert()
                                        .rotationEffect(.degrees(-alpha))
                                        .position(pos)
                                        
                                    
                                 
                                    
                                }
                                
                                // Draws the Planets (Sun, Moon, etc..)
                                
                                let planets = natalChart?.planets ?? []
                                
                                ForEach(planets){ planet in
                                    
                                    let sign = planet.sign
                                    let deg = planet.angle
                                    
                                    /// Angle relative to aries 0 deg
                                    let relative_deg = deg + sign.beginsAt()
                                    
                            
                                    
                                    // tick to put where the planet is
                                    Tick(x_center: Double(x_center), y_center: Double(y_center), radius_of_ticks: Double(radius_of_ticks), theta: relative_deg)
                              
                                    
                                    let pos = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(radius_of_ticks)-Double(10*Int.random(in: 1...5)), theta: relative_deg)
                                    // Planet Symbol should go here
                                    planet.image()
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: CGFloat(d*0.30), height: CGFloat(d*0.30))
                                        .colorInvert()
                                        .rotationEffect(.degrees(-alpha))
                                        .position(pos)
                                    
                                    
                                        
                                        
                                }
                                
                                
                            }
                            
                        }.frame(width: outerCircleGeometry.size.width - CGFloat(d), height: outerCircleGeometry.size.height - CGFloat(d))
                        
                        
                        
                    
                        
                        
                        
                            
                           
                    }
                        
                    
                    
                }.frame(width: (R != .infinity) ? CGFloat(2*R): .infinity, height: (R != .infinity) ? CGFloat(2*R): .infinity)
                .rotationEffect(.degrees(alpha))
               
            
                
            
                
            
            
        
        
            
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
            
            
            
            return NatalChartView(alpha: -1*rotation_offset, natalChart: with)
                //.rotate(degrees: rotation_offset )
        }
        /// - WARNING: setting alpha to -180 by default here will cancel spin annimation on initalization if ascendant is not given
        return NatalChartView( alpha: -180, natalChart: with)
        
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
    func make(with: NatalChart?) -> some View {
        modifier(Make(with: with))
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
