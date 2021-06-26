//
//  FromWhereView.swift
//  Love
//
//  Created by Micheal Bingham on 6/19/21.
//

import SwiftUI
import MapKit

struct FromWhereView: View {
    
    @EnvironmentObject private var account: Account
    
    
        /// Center of map view. Change to current location in future.
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    @State private var goToNext: Bool = false 
    
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                // Background Image
                Image("backgrounds/background1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .navigationTitle("Where are you from?")
                    .navigationBarColor(backgroundColor: .clear, titleColor: .white)
                
                // ******* ======  Transitions -- Navigation Links =======
                
                // Goes to the Profile
                NavigationLink(
                    destination: LiveWhereView(),
                    isActive: $goToNext,
                    label: {  EmptyView()  }
                )
                
                // ******* ================================ **********
                
                
                Map(coordinateRegion: $region)
                    .frame(width: 400, height: 300)
                
                
                
                
            }
            .onAppear {
                doneWithSignUp(state: false)
            }
            
          
       
        }
       
    }
    
    
}

struct FromWhereView_Previews: PreviewProvider {
    static var previews: some View {
        FromWhereView()
    }
}
