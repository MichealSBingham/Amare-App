//
//  UserProfileViewDataModel.swift
//  Amare
//
//  Created by Micheal Bingham on 1/17/22.
//

import Foundation
import Firebase


/// Class for view model of  a user shown on screen
class UserProfileViewDataModel: ObservableObject{
    
    @Published var userData: AmareUser?
    
    private var db = Firestore.firestore()
    
    private var userDataSnapshotListener: ListenerRegistration?
    
    
    
}
