//
//  SearchOtherUsersView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/18/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct SearchOtherUsersView: View {
    
    var names = ["Micheal", "Eric", "Daniel", "Zach", "Trevor"]
    var persons: [QueryDocumentSnapshot] = []
    var body: some View {
        
      // VStack{
            
          
               
               ScrollView{
                       
                      //VStack{
                           
                           ForEach(persons, id: \.self){ person in
                               
                               let data = person.data()
                              // let id = data["id"] as! String
                               
                               Button {
                                   // Send notification to view that we tapped a user
                                   NotificationCenter.default.post(name: NSNotification.loadUserProfile, object: person.documentID)
                               } label: {
                                   
                                   Text(data["name"] as! String)
                                   
                                   
                               }
                               
                               Divider()

                           
                               
                           }
                       //}
                      
                       
               }.frame(maxWidth: .infinity, maxHeight: 150)
           
                
           
            
      // }
        .background(.ultraThinMaterial)
       .foregroundColor(.pink)
        .foregroundStyle(.ultraThinMaterial)
        .cornerRadius(20)
       // .frame(width: 250, height: 250)
    }
}

struct SearchOtherUsersView_Previews: PreviewProvider {
    static var previews: some View {
        SearchOtherUsersView().preferredColorScheme(.dark)
    }
}
