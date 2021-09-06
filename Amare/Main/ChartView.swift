//
//  ChartView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject private var account: Account
    
    @State private var deg: Double = 0
    
    var body: some View {
        
        VStack{
            Text("\(deg)")
            
            
            ZStack{
                
                Button("Spin") {
                    
                    withAnimation(Animation.easeInOut(duration: 3)) {
                        deg = Double.random(in: 0...360)
                    }
                    

                }
                    
              
                NatalChartView()
                    .rotate(degrees: deg)
                    
                      
                
                
                
                
            }
        }
        
      
        
        
    }
}


extension BinaryFloatingPoint {
    /// Converts decimal degrees to degrees, minutes, seconds
    var dms: String {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        
        let minutes = seconds / 60
        let Seconds = seconds % 60
        
        
        return "\(degrees)°\(minutes)'\(Seconds)"
        
    }
    
    
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach([ "iPhone 8", "iPhone 12 Pro Max"], id: \.self) { deviceName in
                       ChartView()
                            .previewDevice(PreviewDevice(rawValue: deviceName))
                            .previewDisplayName(deviceName)
                            .environmentObject(Account())
                        .preferredColorScheme(.dark)
                  }
        
      
        
    }
}


