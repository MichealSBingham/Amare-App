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
                            .foregroundColor(.white)
                            .frame(height: 8)
                            .offset(x: 30)
                    }
                   
                    
                    HStack {
                        Text(model.user?.locationSettings?.rawValue ?? "Nothing")
                            .redacted(reason:
                                      model.user?.locationSettings ==  nil ? .placeholder: [])
                            .font(.headline)
                            .bold()
                            .foregroundColor((model.user?.locationSettings ?? .off) == .off ? .primary : .amare )
                        
                    }
                }
               
                

                Text(model.user?.locationSettings?.description ?? "Nothing set yet")
                    .redacted(reason:
                              model.user?.locationSettings ==  nil ? .placeholder: [])
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
        
        
        
    }

    func updatePrivacySetting(_ setting: LocationPrivacySettings) {
      
        DispatchQueue.main.async {
            FirestoreService.shared.update(location: setting) { error in
                
            }
        }
        
    }
}


#Preview {
    ZStack{
      
        LocationPrivacyCapsule()
            .environmentObject(UserProfileModel())
        
    }
    
}
