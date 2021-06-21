//
//  LiveWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit

struct LiveWhereView: View {
    
    
    /// Center of map view. Change to current location in future.
@State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))



var body: some View {
    
    NavigationView{
        
        ZStack{
            
            // Background Image
            Image("backgrounds/background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("Where do you live?")
                .navigationBarColor(backgroundColor: .clear, titleColor: .white)
            
            
            Map(coordinateRegion: $region)
                .frame(width: 400, height: 300)
            
            
            
            
        }
        
    }
   
}
}

struct LiveWhereView_Previews: PreviewProvider {
    static var previews: some View {
        LiveWhereView()
    }
}
