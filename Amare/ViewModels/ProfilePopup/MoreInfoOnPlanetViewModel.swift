//
//  MoreInfoOnPlanetViewModel.swift
//  Amare
//
//  Created by Micheal Bingham on 2/13/22.
//

import Foundation
import Firebase




class MoreInfoOnPlanetViewModel: ObservableObject{
    
    
      @Published var friendsWithThisPlacement =  [AmareUser]()
      @Published var notablePeopleWithThisPlacement =  [AmareUser]()
    

    
    private var notablePlacementsListener: ListenerRegistration?
    private var friendsWithPlacementsListener: ListenerRegistration?


    
    private var db = Firestore.firestore()
    
    /// Cleans out the array and detaches listeners
    func stopLookingForPeopleWithAspect()  {
        
        //friendsWithThisPlacement = []
        //notablePeopleWithThisPlacement = []
        friendsWithPlacementsListener?.remove()
        notablePlacementsListener?.remove()
    }
    
    /// Finds other users with the same placement as given below.
    ///  - user: defaulty the current signed in user. For instance if you change this to 'david_uid' it'll be david's friends with this particular placement
    func findPeople(with placement: Planet, of user: String? = Auth.auth().currentUser?.uid)  {
        
        print("Finding people with placemenet \(placement)")
        // find all notable people with this placement
                                         // (Planet)  | | (Sign) | |
        
        
        notablePlacementsListener = db.collection("all_placements")
            .document(placement.name.rawValue)
            .collection(placement.sign.rawValue)
            .addSnapshotListener { querySnapshot, error in
                
                
                guard let documents = querySnapshot?.documents else {  print("No documents with placement"); return }
                
                var people: [AmareUser] = documents.map({ (queryDocumentSnapshot) -> AmareUser in
                    
                    let data = queryDocumentSnapshot.data()
                    
                    print("Found user with placement: \(data)")
                    
                    let uid = queryDocumentSnapshot.documentID
                    
                    
                    
                    
                    return AmareUser(id: uid)
                    
                    
                })
                
                //guard !people.isEmpty else {return }
                self.notablePeopleWithThisPlacement = people
            }
        
        
        
        if let id = user {
            
            /*friendsWithPlacementsListener =*/    db.collection("friends")
                .document(id)
                .collection(placement.name.rawValue)
                .document("doc")
                .collection(placement.sign.rawValue)
                .addSnapshotListener { querySnapshot, error in
                    
                    
                    guard let documents = querySnapshot?.documents else {  print("No documents with placement"); return }
                    
                    var people: [AmareUser] = documents.map({ (queryDocumentSnapshot) -> AmareUser in
                        
                        let data = queryDocumentSnapshot.data()
                        
                        
                        let uid = queryDocumentSnapshot.documentID
                        
                        
                        
                        
                        return AmareUser(id: uid)
                        
                        
                    })
                    
                   // guard !people.isEmpty else {return }
                    
                    print("Found \(people.count) users with placement: \(placement.name.rawValue)")


                    self.friendsWithThisPlacement = people
                }
        }
        
        
        
            //.query()
            
    }
    
    
}
