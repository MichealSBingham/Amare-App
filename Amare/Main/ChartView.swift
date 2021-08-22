//
//  ChartView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject private var account: Account
    
    var body: some View {
        
        
        VStack{
            
            Text("This is **BETA**. This is a test to see if our API is pulling your proper natal chart. It will **NOT** look like this in the production version.")
                .foregroundColor(.white)
                
            Spacer()
            
            let name = account.data?.name ?? ""
            Text("\(name)'s Natal Chart")
            
            Spacer()
            ForEach(account.data?.natal_chart?.planets ?? []){ planet in
            
                let planet_name = planet.name
                let sign = planet.sign
                let angle = planet.angle
                let element = planet.element
                
                let ptext = "\(planet_name.rawValue)\t\(sign.rawValue) \(angle.dms) deg\t\(element.rawValue)\tCusp? \(planet.is_on_cusp) Cusp Sign \(planet.almost?.cusp_sign.rawValue ?? "None")"
                
                Text(ptext)
                
            }
            
            
            
            
        }.onAppear {
            
            var natalisnil: Bool  = account.data?.natal_chart  == nil
            print("chart is nil? \(natalisnil)")

            
        }
        
        
    }
}


extension BinaryFloatingPoint {
    /// Converts decimal degrees to degrees, minutes, seconds
    var dms: (degrees: Int, minutes: Int, seconds: Int) {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        return (degrees, seconds / 60, seconds % 60)
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


