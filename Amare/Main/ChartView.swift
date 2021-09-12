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
    
    @State var didChangeCharts: Bool = false
    
    @State var person1: String = "Your Natal Chart"
    @State  var person2: String = ""

    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    //@State private var viewState = CGSize.zero

    
    
    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    var simpleDrag: some Gesture {
            DragGesture()
                .onChanged { value in
                    print("changed to .. \(value)")
                    self.location = value.location
                }
        }
    
    var body: some View {
        
        
        
        ZStack{
            
            Background()
            
            VStack{
                
                HStack{
                    
                    Spacer()
                    Text( person2.isEmpty ? "\(person1)'s Natal Chart" : "\(person1) and \(person2)'s Synastry Chart")
                        .offset( y: 20)
                        .padding()
                    
                    Spacer()
                }
                
                Spacer()
            }
            
         
                
                NatalChartView()
                    .make(with: chart/*, shownAspect: aspectToGet*/)
                    .animation(.easeIn(duration: 3))
                    .onReceive(Just(account), perform: { _ in
                
                        guard !didChangeCharts else { return }
                        
                        AmareApp().delay(1) {
                            
                            person1 = account.data?.name ?? ""
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
                        
                        var ids = ["6K3xXehsHBVXA5KrZvwPFkCikF73": "Lily", "DI8bW3wCcvPl6Xxigd5936lYn363": "Eric", "pIsF8X2k4COgwSRaZNGGtC3zatf1": "Micheal", "q7PxPu7095eSrmZoG1sO1zncty32": "David", "zoWurg8bnDXwNMGC2fXml9cvtGq2": "Someone born Yesterday" ]
                        
                        
                        let randomPerson = ids.keys.randomElement() ?? ""
                        
                        guard randomPerson != account.data?.id else {
                            chart = nil
                            chart = account.data?.natal_chart
                            return
                        }
                        
                        person2 = ids[randomPerson] ?? ""
                        
                        didChangeCharts = true
                       
                        
                        account.getNatalChart(from: randomPerson ?? "" , isOuterChart: true) { error, natal in
                            
                            didChangeCharts = true
                            chart?.synastryPlanets = natal?.planets
                            chart?.synastryAngles = natal?.angles
                        }
                    }
                    .position(location)
                    .gesture(
                                    simpleDrag
                                )
                    
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture()
                                .onChanged { val in
                                    let delta = val / self.lastScale
                                    self.lastScale = val
                                    if delta > 0.94 { // if statement to minimize jitter
                                        let newScale = self.scale * delta
                                        self.scale = newScale
                                    }
                                }
                                .onEnded { _ in
                                    self.lastScale = 1.0
                                }
                            )
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


