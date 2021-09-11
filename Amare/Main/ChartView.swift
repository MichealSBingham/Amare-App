//
//  ChartView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import Combine

struct ChartView: View {
    @EnvironmentObject private var account: Account
    
    @State private var deg: Double = 0
    @State private var space: Double = 150
    @State private var radius: CGFloat = .infinity
    
    @State private var chart: NatalChart?
    
    @State var aspectToGet: AspectType = .all
    
    @State var showBottomPopup: Bool = false
    
    @State var infoToShow: String?

    
    var body: some View {
        
        
        
        ZStack{
            
            Background()
            
            NatalChartView()
                .make(with: chart/*, shownAspect: aspectToGet*/)
                .animation(.easeIn(duration: 3))
                .onReceive(Just(account), perform: { _ in
            
                    AmareApp().delay(1) {
                        
                        chart = account.data?.natal_chart
                     
                    }
                    
                })
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.wantsMoreInfoFromNatalChart)) { obj in
                   
                    showBottomPopup = true
                    
                    if let sign = obj.object as? ZodiacSign{
                        
                        infoToShow = sign.rawValue
                    }
                    
                    if let planet = obj.object as? Planet{
                        
                        infoToShow = planet.name.rawValue
                    }
                    
                    if let house = obj.object as? House{
                        
                        infoToShow = String(house.ordinality)
                    }
                    
                    if let angle = obj.object as? Angle{
                        
                        infoToShow = angle.name.rawValue
                    }
                 //   infoToShow = (obj.object as? ZodiacSign)?.rawValue }
                
                }
                .onTapGesture {
                    account.getNatalChart(from: "q7PxPu7095eSrmZoG1sO1zncty32" ) { error, natal in
                        
                        chart?.synastryPlanets = natal?.planets
                    }
                }
                
                .padding()
            
            
        }
        .popup(isPresented: $showBottomPopup, type: .toast, position: .bottom) {
            // your content
            Text("\(infoToShow ?? "")")
                            .frame(width: 200, height: 200)
                            .background(Color(red: 0.85, green: 0.8, blue: 0.95))
                            .cornerRadius(30.0)
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


