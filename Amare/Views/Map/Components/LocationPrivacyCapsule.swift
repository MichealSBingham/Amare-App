//
//  LocationPrivacyCapsule.swift
//  Amare
//
//  Created by Micheal Bingham on 11/30/23.
//

import SwiftUI


struct LocationPrivacyCapsule: View {
    
    @EnvironmentObject var model: UserProfileModel
    
  
    @State private var showMenu = false

    var body: some View {
        Menu{
            
            Button("Only show my approximate location") { updatePrivacySetting(.approximate) }
                        Button("Hide my location") { updatePrivacySetting(.off) }
                        Button("Only those that pass by me can see me") { updatePrivacySetting(.on) }
            
        }  label: {
            VStack(spacing: 1) { // Reduced spacing between text and description
                ZStack{
                    HStack{
                        
                        
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 8)
                            .offset(x: 30)
                    }
                   
                    
                    HStack {
                        Text(model.user?.locationSettings?.rawValue ?? "OFF")
                            .font(.headline)
                            .bold()
                            .foregroundColor(model.user?.locationSettings? == .off ? .primary : .amare )
                        
                    }
                }
               
                

                Text(model.user?.locationSettings.rawValue.description ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10) // Adjust padding for horizontal
            .padding(.vertical, 8) // Adjust padding for vertical
            .background(
                Capsule().fill(Color(.systemBackground).opacity(0.5))
                        .overlay(Capsule().strokeBorder(Color.gray, lineWidth: 1))
            )
        }
        
        
        /*
        .buttonStyle(PlainButtonStyle())
        .actionSheet(isPresented: $showMenu) {
            ActionSheet(
                title: Text("Privacy Setting"),
                buttons: [
                    .default(Text("Only show my approximate location")) { updatePrivacySetting(.approximate) },
                    .default(Text("Hide my location")) { updatePrivacySetting(.off) },
                    .default(Text("Only those that pass by me can see me")) { updatePrivacySetting(.on) },
                    .cancel()
                ]
            )
        }
        */
    }

    func updatePrivacySetting(_ setting: LocationPrivacySettings) {
      
        FirestoreService.shared.update(location: setting) { error in
            print("some error happened updating location")
        }
    }
}


#Preview {
    ZStack{
      
        LocationPrivacyCapsule()
    }
    
}
