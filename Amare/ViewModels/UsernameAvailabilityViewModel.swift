//
//  UsernameAvailabilityViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 1/14/22.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

/// View model for determining if a username is available or not
class UsernameAvailabilityViewModel: ObservableObject{
    
    /// Username given, this view model should automatically remove any '@'  symbols.
  // @State var username: String = ""
    
    @Published var isAvailable: Bool = false
    
    private var db = Firestore.firestore()
    
    
    /// Checks if  `username` is available by changing the `isAvailable` property. This view model should automatically remove any '@'  symbols.
    func check( username: String)  {
        
        
        var nametolookfor:String  = username.replacingOccurrences(of: "@", with: "")
        
        
        print("Checking for .. \(nametolookfor)")
        guard !nametolookfor.isEmpty else { isAvailable = false ; return }
        
        db.collection("usernames").document(nametolookfor).getDocument(completion: { doc, error in
            
           
            if (doc?.exists ??  false ) {
                
                withAnimation {
                    self.isAvailable = false
                }
            } else {
                
                withAnimation{
                    self.isAvailable = true
                }
                
                
            }
            
            
        })
    }
    
    
    
}


/// View Model for obtaining the signed in user's data and will tell you if it's complete or not
class HomeViewModel: ObservableObject{
    
    @Published var userData: AmareUser?
    
    /// Will be true if the user has incomplete data in the database so some error happened during account creation/signup process so sign the user out if this happens so they can resign up. 
    @Published var inCompleteData: Bool = false
    
    private var db = Firestore.firestore()
    
    
    /// Subscribes to changes to the current signed in user's data
    func subscribeToUserDataChanges()  {
        
        print("***Subscribing to user data changes")
        if let id = Auth.auth().currentUser?.uid {
            
            
            db.collection("users").document(id).addSnapshotListener { snapshot, error in
                
                print("The id is ... \(id)")
                
                print("The snapshot is \(snapshot) does it exist? \(snapshot?.exists) and error is \(error)")
                
                // Make sure the document exists
                guard snapshot?.exists ?? false else {
                    self.inCompleteData = true
                    print("Snapshot doesn't exist ")
                    return
                }
                
            
                // Convert to AmareUser object
                let result = Result {
                    try snapshot?.data(as: AmareUser.self)
                }
                
                switch result {
                case .success(let success):
                    print("***There was success grabbing user \(success) is complete: \(success?.isComplete())")
                    self.userData = success
                    
                    // check if the user data is complete
                    if let isComplete = success?.isComplete() {
                        
                        self.inCompleteData = !isComplete
                    }  else {
                        self.inCompleteData = true
                    }
                case .failure(let failure):
                    
                    print("**The enrror grabbing user data is .. \(failure)")
                    
                }
                
            }
            
        }
        
        
       
        
    }
}
