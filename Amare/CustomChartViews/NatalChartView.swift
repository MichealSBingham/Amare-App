//
//  NatalChartView.swift
//  NatalChartView
//
//  Created by Micheal Bingham on 9/4/21.
//

import SwiftUI

struct NatalChartView: View {
    
    /// Radius of the outer circle or frame size.
    let R: Double  = 0
    
    /// Distance between outer and inner circles . (R - r = d) --> r = R - d or
    let d: Double = 45
    
    var body: some View {
        
    
                ZStack{
                    
                    // Outer Wheel
                        Circle()
                            .stroke()
                            .frame(width: (R > 0) ? CGFloat(2*R): .infinity, height: (R > 0) ? CGFloat(2*R): .infinity)
                           
                    
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
                                    
                                
                                    
                                    //points.append(mid)
                                    
                                    // Coordinates for the sign symbols on the wheel
                                    let phi = Double(15 + (30*n))
                                    let r_prime =  (r+R_)/2
                                    
                                    let pointToPlace = polar(x_center: Double(x_center), y_center: Double(y_center), r: Double(r_prime), theta: phi)
                                    
                                    let sign = ZODIAC_SIGNS[n2-1]
                                    
                                    
                                     sign.image()
                                        .rotationEffect(.degrees(46.8))
                                        .position(x: pointToPlace.x, y: pointToPlace.y)
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }.frame(width: outerCircleGeometry.size.width - CGFloat(d), height: outerCircleGeometry.size.height - CGFloat(d))
                        
                        
                        
                    
                        
                        
                        
                            
                           
                    }
                        
                    
                    
                }.frame(width: (R > 0) ? CGFloat(2*R): .infinity, height: (R > 0) ? CGFloat(2*R): .infinity)
                .rotationEffect(.degrees(-46.8))
               
            
                
            
                
            
            
        
        
            
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
              .stroke(/*.white*/)
              
              
        //  }
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
